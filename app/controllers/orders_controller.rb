class OrdersController < ApplicationController
  def cart
    @order = current_order
  end

  def put_to_cart
    #current_order.line_items
    redirect_to :cart
  end

  def remove_from_cart
    redirect_to :cart
  end

  def checkout
  end

  private
    def current_order
      Spree::Order.incomplete.first || Order.create(order_params)
    end

    def order_params
      params[:created_by_id] = try_spree_current_user.try(:id)
      params.permit(:created_by_id)
    end
end
