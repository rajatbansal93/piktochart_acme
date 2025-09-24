require "bigdecimal"

class ShippingRule
  def calculate(subtotal)
    raise NotImplementedError
  end
end

class TieredShippingRule < ShippingRule
  def initialize(thresholds:)
    @thresholds = thresholds.map do |t|
	  { limit: BigDecimal(t[:limit].to_s), cost: BigDecimal(t[:cost].to_s) }
	end
  end

  def calculate(subtotal)
    @thresholds.find { |t| subtotal < t[:limit] }[:cost]
  end
end
