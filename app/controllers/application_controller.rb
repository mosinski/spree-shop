class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :categories, :brands

  def categories
    categories = Spree::Taxon.find_by_name("Categories")
    if categories
      return Spree::Taxon.where(parent_id: categories.id) || []
    else
      return []
    end
  end

  def brands
    brands = Spree::Taxon.find_by_name("Brands")
    if brands
      return Spree::Taxon.where(parent_id: brands.id) || []
    else
      return []
    end
  end
end
