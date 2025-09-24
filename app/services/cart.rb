class Cart
  def initialize(catalogue:, shipping_rule:, discount_rules: [])
    @catalogue = catalogue
    @shipping_rule = shipping_rule
    @discount_rules = discount_rules
    @items = {}
  end

  def add(sku, qty = 1)
    product = @catalogue.find(sku)
    @items[sku] ||= CartItem.new(product)
    @items[sku].increment(qty)
  end

  def items
    @items.values
  end

  def subtotal
    items.sum(&:subtotal)
  end

  def discounts
    @discount_rules.sum { |rule| rule.apply(items) }
  end

  def shipping
    @shipping_rule.calculate(subtotal - discounts)
  end

  def total
    (subtotal - discounts + shipping).round(2)
  end
end
