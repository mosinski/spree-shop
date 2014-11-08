class ProductsController < ApplicationController
  def index
    @products = Spree::Product.all.search(params[:search]).select{|product| product.images.present?&&(product.total_on_hand > 0)}
    @products = @products.select{|product| product.price >= params[:price_min].to_i} if params[:price_min].present?
    @products = @products.select{|product| product.price <= params[:price_max].to_i} if params[:price_max].present?
    @products = @products.paginate(page: params[:page], per_page: 9)
    @category = Spree::Taxon.where(id: params[:category]) if params[:category]
    unless @category.empty?
      @category = [@category.first.parent] if !@category.first.children.present?
    end
  end

  def show
    @product = Spree::Product.friendly.find(params[:id])
  end
end
