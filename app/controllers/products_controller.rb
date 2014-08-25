class ProductsController < ApplicationController
  def index
    @products = Spree::Product.all.select{|product| product.available?&product.images.present?&(product.total_on_hand > 0)}
  end

  def show
    @product = Spree::Product.friendly.find(params[:id])
  end
end
