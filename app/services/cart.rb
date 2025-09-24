require "bigdecimal"
require_relative '../models/cart_item'

class Cart
  def initialize(catalogue:, shipping_rule:, discount_rules: [], currency_converter: nil, currency: "USD")
    @catalogue = catalogue
    @shipping_rule = shipping_rule
    @discount_rules = discount_rules
    @currency_converter = currency_converter
    @currency = currency
    @items = {}
  end

  def add(sku, qty = 1)
    product = @catalogue.find(sku)
    if @items[sku]
      @items[sku].increment(qty)
    else
      @items[sku] = CartItem.new(product, qty)
    end
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

  def total_in_currency(target_currency)
    return total if target_currency == @currency
    @currency_converter.convert(total, from: @currency, to: target_currency)
  end
end
