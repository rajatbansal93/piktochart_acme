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
    end.sort_by { |t| -t[:limit] }
  end

  def calculate(subtotal)
    subtotal = BigDecimal(subtotal.to_s)
    tier = @thresholds.find { |t| subtotal >= t[:limit] }
    tier ? tier[:cost] : @thresholds.last[:cost]  # fallback to lowest tier
  end
end
