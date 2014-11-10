class ApplicationController < ActionController::Base
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::StrongParameters
  helper Spree::Core::Engine.helpers

  layout 'application'

  protect_from_forgery with: :exception
  helper_method :categories, :brands, :cart_items_count

  def categories
    if categories = Spree::Taxon.find_by_name("Categories")
      return Spree::Taxon.where(parent_id: categories.id) || []
    else
      return []
    end
  end

  def brands
    if brands = Spree::Taxon.find_by_name("Brands")
      return Spree::Taxon.where(parent_id: brands.id) || []
    else
      return []
    end
  end

  def cart_items_count
    current_order && current_order.line_items.count || 0
  end
end
