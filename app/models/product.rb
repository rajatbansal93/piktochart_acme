require "bigdecimal"

class Product
  attr_reader :sku, :name, :price, :currency

  def initialize(sku:, name:, price:, currency: "USD")
    @sku = sku.freeze
    @name = name.freeze
    @price = BigDecimal(price.to_s).freeze
    @currency = currency.freeze
  end
end
