class Cart
  def initialize(catalogue:)
    @catalogue = catalogue
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

  def total
    subtotal
  end
end
