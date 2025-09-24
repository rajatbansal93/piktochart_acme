class ShippingRule
  def calculate(subtotal)
    raise NotImplementedError
  end
end

class TieredShippingRule < ShippingRule
  def initialize(thresholds:)
    @thresholds = thresholds
  end

  def calculate(subtotal)
    @thresholds.find { |t| subtotal < t[:limit] }[:cost]
  end
end
