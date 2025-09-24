class Checkout
  def initialize(cart:)
    @cart = cart
  end

  def scan(sku, qty = 1)
    @cart.add(sku, qty)
  end

  def total
    @cart.total
  end
end
