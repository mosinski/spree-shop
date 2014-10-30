Spree::Price.class_eval do
  def self.min
    min = order("amount ASC").first
    min.nil? ? 0 : min.amount.ceil
  end

  def self.max
    max = order("amount DESC").first
    max.nil? ? 0 : max.amount.ceil
  end
end
