require "bigdecimal"

class DiscountRule
  def apply(items)
    raise NotImplementedError
  end
end

class BuyOneGetSecondHalfPrice < DiscountRule
  def initialize(sku:)
    @sku = sku
  end

  def apply(items)
    item = items.find { |i| i.product.sku == @sku }
    return 0 unless item

    eligible_pairs = item.quantity / 2
    discount_per_pair = item.product.price / BigDecimal("2")
    BigDecimal(eligible_pairs.to_s) * discount_per_pair
  end
end
