class ProductsController < ApplicationController
  def index
    @products = Spree::Product.all.select{|product| product.available?&product.images.present?&(product.total_on_hand > 0)}
  end

  def show
  end
end
