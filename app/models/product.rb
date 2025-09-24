class Product
  attr_reader :sku, :name, :price, :currency

  def initialize(sku:, name:, price:, currency: "USD")
    @sku = sku.freeze
    @name = name.freeze
    @price = price.to_f.freeze
    @currency = currency.freeze
  end
end
