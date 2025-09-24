class Checkout
  def initialize(cart:)
    @cart = cart
  end

  def scan(sku, qty = 1)
    @cart.add(sku, qty)
  end

  def total(currency: nil)
    currency ? @cart.total_in_currency(currency) : @cart.total
  end
end
