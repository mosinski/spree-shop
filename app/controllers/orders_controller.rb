class OrdersController < ApplicationController
  def cart
    @order = current_order
  end

  def put_to_cart
    quantity = 1 unless params[:quantity]
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)

    if populator.populate(params[:variant_id], quantity, params[:options])
      redirect_to :cart
    else
      flash[:error] = populator.errors.full_messages.join(" ")
      redirect_back_or_default(spree.root_path)
    end
  end

  def remove_from_cart
    redirect_to :cart
  end

  def checkout
  end

  private
    def current_order(options = {})
      options[:create_order_if_necessary] ||= false
      options[:lock] ||= false

      return @current_order if @current_order

      # Find any incomplete orders for the guest_token
      @current_order = Spree::Order.incomplete.includes(:adjustments).lock(options[:lock]).find_by(current_order_params)

      if options[:create_order_if_necessary] and (@current_order.nil? or @current_order.completed?)
        @current_order = Spree::Order.new(current_order_params)
        @current_order.user ||= try_spree_current_user
        # See issue #3346 for reasons why this line is here
        @current_order.created_by ||= try_spree_current_user
        @current_order.save!
      end

      if @current_order
        #@current_order.last_ip_address = ip_address
        return @current_order
      end
    end

    def current_order_params
      params[:created_by_id] = current_user.id
      params.permit(:created_by_id)
    end

    def current_currency
      Spree::Config[:currency]
    end
end
