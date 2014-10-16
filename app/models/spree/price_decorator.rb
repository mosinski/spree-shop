Spree::Price.class_eval do
  def self.min
    order("amount ASC").first.amount.ceil || 0
  end

  def self.max
    order("amount DESC").first.amount.ceil || 0
  end
end
