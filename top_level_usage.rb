# frozen_string_literal: true

require "bigdecimal"
require_relative 'app/models/product'
require_relative 'app/models/catalogue'
require_relative 'app/services/shipping_rule'
require_relative 'app/services/discount_rule'
require_relative 'app/services/currency_converter'
require_relative 'app/services/cart'
require_relative 'app/services/checkout'

catalogue = Catalogue.new([
  Product.new(sku: "R01", name: "Red Widget", price: BigDecimal("32.95"), currency: "USD"),
  Product.new(sku: "G01", name: "Green Widget", price: BigDecimal("24.95"), currency: "USD"),
  Product.new(sku: "B01", name: "Blue Widget", price: BigDecimal("7.95"), currency: "USD")
])

shipping_rule = TieredShippingRule.new(
  thresholds: [
    { limit: BigDecimal("90"), cost: BigDecimal("0.00") },
    { limit: BigDecimal("50"), cost: BigDecimal("2.95") },
    { limit: BigDecimal("0"),  cost: BigDecimal("4.95") }
  ]
)

discounts = [BuyOneGetSecondHalfPrice.new(sku: "R01")]

converter = CurrencyConverter.new({ "USD_EUR" => 0.91, "USD_INR" => 83.0 })

cart = Cart.new(
  catalogue: catalogue,
  shipping_rule: shipping_rule,
  discount_rules: discounts,
  currency_converter: converter,
  currency: "USD"
)

checkout = Checkout.new(cart: cart)
checkout.scan("R01", 2)
checkout.scan("B01", 1)

puts "Cart total: $#{checkout.total.to_s('F')}"  # USD => 54.37
puts "Cart total: $#{checkout.total(currency: "EUR").to_s('F')}"

