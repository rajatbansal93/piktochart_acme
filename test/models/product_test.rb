require_relative "../test_helper"

class ProductTest < Minitest::Test
  def setup
    @product = Product.new(
      sku: "R01",
      name: "Red Widget",
      price: BigDecimal("32.95")
    )
  end

  def test_product_attributes
    assert_equal "R01", @product.sku
    assert_equal "Red Widget", @product.name
    assert_equal BigDecimal("32.95"), @product.price
  end
end
