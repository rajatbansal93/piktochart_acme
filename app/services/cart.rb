require "bigdecimal"

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
    items.map(&:subtotal).reduce(BigDecimal("0"), :+)
  end

  def discounts
    @discount_rules.map { |rule| rule.apply(items) }.reduce(BigDecimal("0"), :+)
  end

  def shipping
    @shipping_rule.calculate(subtotal - discounts)
  end

  def total
    (subtotal - discounts + shipping).truncate(2)
  end
end
