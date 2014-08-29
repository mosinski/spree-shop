class OrdersController < ApplicationController
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order

  layout 'application'

  def cart
    @order = current_order || Spree::Order.new
    associate_user
  end

  def put_to_cart
    quantity = 1 unless params[:quantity]
    populator = Spree::OrderPopulator.new(current_order(create_order_if_necessary: true), current_currency)
    if populator.populate(params[:variant_id], quantity, params[:options])
      redirect_to cart_path
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
end
