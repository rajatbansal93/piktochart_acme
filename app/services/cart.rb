class Cart
  def initialize(catalogue:, shipping_rule:)
    @catalogue = catalogue
    @shipping_rule = shipping_rule
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

  def shipping
    @shipping_rule.calculate(subtotal)
  end

  def total
    (subtotal + shipping).round(2)
  end
end
