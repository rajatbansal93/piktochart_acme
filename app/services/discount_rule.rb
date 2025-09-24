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

    pairs = item.quantity / 2
    discount_per_pair = item.product.price / 2
    pairs * discount_per_pair
  end
end
