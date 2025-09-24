require "bigdecimal"

class CartItem
  attr_reader :product, :quantity

  def initialize(product, quantity = 1)
    @product = product
    @quantity = quantity
  end

  def increment(qty = 1)
    @quantity += qty
  end

  def subtotal
    product.price * BigDecimal(quantity.to_s)
  end
end
