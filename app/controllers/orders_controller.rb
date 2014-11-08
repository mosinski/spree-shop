class OrdersController < ApplicationController
  before_action :check_authorization
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404
  helper 'spree/products', 'spree/orders'

  respond_to :html
  
  before_filter :assign_order_with_lock, only: [ :remove_item_cart, :update_cart, :checkout, :update_checkout ]

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
      redirect_back_or_default(spree.root_path)
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
        puts 'TEST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
        flash[:error] = @order.errors.full_messages.join("\n")
        redirect_to checkout_state_path(@order.state) and return
      end

      if @order.completed?
        puts 'TEST------------------------------------'
        @current_order = nil
        flash.notice = Spree.t(:order_processed_successfully)
        flash['order_completed'] = true
        redirect_to completion_route
      else
        puts 'TEST=============================================='
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
end
