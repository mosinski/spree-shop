class OrdersController < ApplicationController
  before_action :check_authorization, except: [:checkout, :update_checkout]
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper 'spree/products', 'spree/orders'

  respond_to :html

  before_filter :assign_order_with_lock, only: [ :remove_item_cart, :update_cart ]
  
  before_action :load_order_with_lock, only: [:checkout, :update_checkout]
  before_filter :ensure_valid_state_lock_version, only: [:update_checkout]
  before_filter :set_state_if_present, only: [:checkout, :update_checkout]

  before_action :ensure_order_not_completed, only: [:checkout, :update_checkout]
  before_action :ensure_checkout_allowed, only: [:checkout, :update_checkout]
  before_action :ensure_sufficient_stock_lines, only: [:checkout, :update_checkout]
  before_action :ensure_valid_state, only: [:checkout, :update_checkout]

  before_action :associate_user, only: [:checkout, :update_checkout]
  before_action :check_authorization_checkout, only: [:checkout, :update_checkout]
  #before_action :apply_coupon_code, only: [:checkout, :update_checkout]

  before_action :setup_for_current_state, only: [:checkout, :update_checkout]

  helper 'spree/orders'

  def cart
    @order = current_order || Spree::Order.new
    associate_user
  end

  def add_item_cart
    quantity = params[:quantity] || 1
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(params[:variant_id], quantity, params[:options])
      redirect_to cart_path
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_back_or_default(root_path)
    end
  end

  def remove_item_cart
    @line_item = @order.line_items.find(params[:variant_id])
    @order.contents.remove(@line_item.variant, @line_item.quantity, {})

    respond_to do |format|
      format.html { redirect_to cart_path }
      format.js
    end
  end

  def update_cart
    if @order.contents.update_cart(order_params)
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next if @order.cart?
            redirect_to checkout_state_path(@order.checkout_steps.first)
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end

  def checkout
    before_address
  end

  def update_checkout
    if @order.update_from_params(params, permitted_checkout_attributes, request.headers.env)
      @order.temporary_address = !params[:save_user_address]
      unless @order.next
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
      else
        redirect_to checkout_state_path(@order.state)
      end
    else
      render :checkout
    end
  end

  private
  def before_address
    # if the user has a default address, a callback takes care of setting
    # that; but if he doesn't, we need to build an empty one here
    @order.bill_address ||= Spree::Address.build_default
    @order.ship_address ||= Spree::Address.build_default if @order.checkout_steps.include?('delivery')
  end

  def check_authorization
    cookies.permanent.signed[:guest_token] = params[:token] if params[:token]
    order = Spree::Order.find_by_number(params[:id]) || current_order

    if order
      authorize! :edit, order, cookies.signed[:guest_token]
    else
      authorize! :create, Spree::Order
    end
  end

  def order_params
    if params[:order]
      params[:order]#.permit(*Spree::permitted_order_attributes)
    else
      {}
    end
  end

  def assign_order_with_lock
    @order = current_order(lock: true)
    unless @order
      flash[:error] = Spree.t(:order_not_found)
      redirect_to root_path and return
    end
  end

  # Checkout

  def ensure_valid_state
    unless skip_state_validation?
      if (params[:state] && !@order.has_checkout_step?(params[:state])) ||
          (!params[:state] && !@order.has_checkout_step?(@order.state))
        @order.state = 'cart'
        redirect_to checkout_state_path(@order.checkout_steps.first)
      end
    end

    # Fix for #4117
    # If confirmation of payment fails, redirect back to payment screen
    if params[:state] == "confirm" && @order.payment_required? && @order.payments.valid.empty?
      flash.keep
      redirect_to checkout_state_path("payment")
    end
  end

  # Should be overriden if you have areas of your checkout that don't match
  # up to a step within checkout_steps, such as a registration step
  def skip_state_validation?
    false
  end

  def load_order_with_lock
    @order = current_order(lock: true)
    redirect_to cart_path and return unless @order
  end

  def ensure_valid_state_lock_version
    if params[:order] && params[:order][:state_lock_version]
      @order.with_lock do
        unless @order.state_lock_version == params[:order].delete(:state_lock_version).to_i
          flash[:error] = Spree.t(:order_already_updated)
          redirect_to checkout_state_path(@order.state) and return
        end
        @order.increment!(:state_lock_version)
      end
    end
  end

  def set_state_if_present
    if params[:state]
      redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      @order.state = params[:state]
    end
  end

  def ensure_checkout_allowed
    unless @order.checkout_allowed?
      redirect_to cart_path
    end
  end

  def ensure_order_not_completed
    redirect_to spree.cart_path if @order.completed?
  end

  def ensure_sufficient_stock_lines
    if @order.insufficient_stock_lines.present?
      flash[:error] = Spree.t(:inventory_error_flash_for_insufficient_quantity)
      redirect_to spree.cart_path
    end
  end

  # Provides a route to redirect after order completion
  def completion_route
    spree.order_path(@order)
  end

  def setup_for_current_state
    method_name = :"before_#{@order.state}"
    send(method_name) if respond_to?(method_name, true)
  end

  def before_address
    # if the user has a default address, a callback takes care of setting
    # that; but if he doesn't, we need to build an empty one here
    @order.bill_address ||= Spree::Address.build_default
    @order.ship_address ||= Spree::Address.build_default if @order.checkout_steps.include?('delivery')
  end

  def before_delivery
    return if params[:order].present?

    packages = @order.shipments.map { |s| s.to_package }
    @differentiator = Spree::Stock::Differentiator.new(@order, packages)
  end

  def before_payment
    if @order.checkout_steps.include? "delivery"
      packages = @order.shipments.map { |s| s.to_package }
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end
    end

    if try_spree_current_user && try_spree_current_user.respond_to?(:payment_sources)
      @payment_sources = try_spree_current_user.payment_sources
    end
  end

  def rescue_from_spree_gateway_error(exception)
    flash.now[:error] = Spree.t(:spree_gateway_error_flash_for_checkout)
    @order.errors.add(:base, exception.message)
    render :edit
  end

  def check_authorization_checkout
    authorize!(:edit, current_order, cookies.signed[:guest_token])
  end
end
