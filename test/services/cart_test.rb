require_relative "../test_helper"

class CartTest < Minitest::Test
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
  end

  def test_empty_cart
    assert_equal BigDecimal("0"), @cart.subtotal
    assert_equal BigDecimal("0"), @cart.discounts
    assert_equal BigDecimal("4.95"), @cart.shipping
    assert_equal BigDecimal("4.95"), @cart.total
  end

  def test_single_item_no_discount
  	@cart.add("G01")
  	assert_equal BigDecimal("24.95"), @cart.subtotal
  	assert_equal BigDecimal("0"), @cart.discounts
  	assert_equal BigDecimal("4.95"), @cart.shipping
  	assert_equal BigDecimal("29.90"), @cart.total
  end

  def test_two_red_items_discount_applied
	@cart.add("R01", 2)
	  expected_subtotal = BigDecimal("32.95") * 2
	  expected_discount = BigDecimal("32.95") / 2
	  expected_shipping = BigDecimal("4.95")
	  expected_total = (expected_subtotal - expected_discount + expected_shipping).truncate(2) # 52.37

	  assert_equal expected_subtotal, @cart.subtotal
	  assert_equal expected_discount, @cart.discounts
	  assert_equal expected_shipping, @cart.shipping
	  assert_equal expected_total, @cart.total
  end

  def test_multiple_items_with_discount
	@cart.add("R01", 3)
	@cart.add("B01", 2)
	subtotal = BigDecimal("32.95") * 3 + BigDecimal("7.95") * 2
	discount = BigDecimal("32.95") / 2
	shipping = BigDecimal("0")
	assert_equal subtotal, @cart.subtotal
	assert_equal discount, @cart.discounts
	assert_equal shipping, @cart.shipping
	assert_equal BigDecimal("98.27"), (@cart.subtotal - @cart.discounts + @cart.shipping).truncate(2)
  end

  def test_total_in_currency_conversion
    @cart.add("R01", 2)
    usd_total = @cart.total
    eur_total = @cart.total_in_currency("EUR")
    assert_equal (usd_total * BigDecimal("0.91")).round(2), eur_total
  end

  def test_total_in_currency_same_as_cart
    @cart.add("R01")
    assert_equal @cart.total, @cart.total_in_currency("USD")
  end
end
