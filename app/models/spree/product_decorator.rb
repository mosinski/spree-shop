Spree::Product.class_eval do
  include ActionView::Helpers::TagHelper

  def self.search(search)
    order('created_at DESC').where('lower(name) LIKE ?', "%#{search}%".downcase)
  end

  def availability
    case
      when self.available? then content_tag(:strong, "In Stock", :class => "text-success")
      when !self.available? then content_tag(:strong, "Out Of Stock", :class => "text-danger")
    end
  end
end
