Spree::Product.class_eval do
  def self.search(search)
    order('created_at DESC').where('name LIKE ?', "%#{search}%")
  end
end
