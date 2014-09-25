class PagesController < ApplicationController
  def home
    @products = Spree::Product.all.select{|product| product.available?&product.images.present?&(product.total_on_hand > 0)}.last(9)
  end

  def about
  end

  def contact
  end

  def error
  end
end
