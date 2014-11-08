class ApplicationController < ActionController::Base
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::StrongParameters
  helper Spree::Core::Engine.helpers

  layout 'application'

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
