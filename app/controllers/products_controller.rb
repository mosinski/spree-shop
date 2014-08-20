class ProductsController < ApplicationController
  def index
    @products = Spree::Product.all
  end

  def show
  end
end
