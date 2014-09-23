class ProductsController < ApplicationController
  def index
    @products = Spree::Product.all.search(params[:search]).select{|product| product.available?&product.images.present?&(product.total_on_hand > 0)}.paginate(page: params[:page], per_page: 9)
  end

  def show
    @product = Spree::Product.friendly.find(params[:id])
  end
end
