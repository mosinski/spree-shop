class ApplicationController < ActionController::Base
  include Spree::Core::ControllerHelpers::Auth
  include Spree::Core::ControllerHelpers::Common
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::StrongParameters

  helper Spree::Core::Engine.helpers

  layout 'application'

  protect_from_forgery with: :exception
  helper_method :categories, :brands, :cart_items_count

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

  def categories(category=nil)
    categories = Spree::Taxon.find_by_name("Categories")
    if category
      categories = Spree::Taxon.where(id: category.id)
      if categories[0].children.empty?
        return categories.map do |c|
          {id: c.parent_id, name: c.parent.name, children: c.parent.children.map{|f| [f.id, f.name, f.products.count]}}
        end
      end
    else
      categories = Spree::Taxon.where(parent_id: categories.id)
    end
    categories.map{|c| {id: c.id, name: c.name, children: c.children.map{|f| [f.id, f.name, f.products.count]}}}
  end
end
