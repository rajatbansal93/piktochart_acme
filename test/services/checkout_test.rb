require_relative "../test_helper"

class CheckoutTest < Minitest::Test
  def setup
    @red = Product.new(sku: "R01", name: "Red Widget", price: BigDecimal("32.95"))
    @green = Product.new(sku: "G01", name: "Green Widget", price: BigDecimal("24.95"))
    @blue = Product.new(sku: "B01", name: "Blue Widget", price: BigDecimal("7.95"))

    @catalogue = Catalogue.new([@red, @green, @blue])

    @shipping = TieredShippingRule.new(
      thresholds: [
        { limit: BigDecimal("90"), cost: BigDecimal("0") },
        { limit: BigDecimal("50"), cost: BigDecimal("2.95") },
        { limit: BigDecimal("0"), cost: BigDecimal("4.95") }
      ]
    )

    @discount_rule = BuyOneGetSecondHalfPrice.new(sku: "R01")

    @converter = CurrencyConverter.new({ "USD_EUR" => 0.91, "USD_INR" => 83.0 })

    @cart = Cart.new(
      catalogue: @catalogue,
      shipping_rule: @shipping,
      discount_rules: [@discount_rule],
      currency_converter: @converter,
      currency: "USD"
    )

    @checkout = Checkout.new(cart: @cart)
  end

  def test_scan_single_item
    @checkout.scan("G01")
    assert_equal BigDecimal("24.95"), @cart.subtotal
    assert_equal BigDecimal("0"), @cart.discounts
    assert_equal BigDecimal("4.95"), @cart.shipping
    assert_equal BigDecimal("29.90"), @checkout.total
  end

  def test_scan_multiple_quantities
    @checkout.scan("R01", 2)
    @checkout.scan("B01", 1)

    expected_subtotal = BigDecimal("32.95") * 2 + BigDecimal("7.95") * 1
    expected_discount = BigDecimal("32.95") / 2
    expected_shipping = BigDecimal("2.95")
    expected_total = (expected_subtotal - expected_discount + expected_shipping).truncate(2)

    assert_equal expected_total, @checkout.total
  end

  def test_total_without_currency
    @checkout.scan("R01", 2)
    expected_total = (BigDecimal("32.95") * 2 - (BigDecimal("32.95") / 2) + BigDecimal("4.95")).truncate(2)
    assert_equal expected_total, @checkout.total
  end

  def test_total_with_currency
    @checkout.scan("R01", 2)
    usd_total = @checkout.total
    eur_total = @checkout.total(currency: "EUR")
    expected_eur = (usd_total * BigDecimal("0.91")).round(2)
    assert_equal expected_eur, eur_total
  end
end
