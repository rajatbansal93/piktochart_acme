require_relative "../test_helper"

class CartItemTest < Minitest::Test
  def setup
    @product = Product.new(sku: "R01", name: "Red Widget", price: BigDecimal("32.95"))
  end

  def test_default_quantity
    item = CartItem.new(@product)
    assert_equal 1, item.quantity
  end

  def test_custom_quantity
    item = CartItem.new(@product, 5)
    assert_equal 5, item.quantity
  end

  def test_increment_quantity
    item = CartItem.new(@product, 2)
    item.increment
    assert_equal 3, item.quantity

    item.increment(4)
    assert_equal 7, item.quantity
  end

  def test_subtotal
    item = CartItem.new(@product, 3)
    expected = BigDecimal("32.95") * BigDecimal("3")
    assert_equal expected, item.subtotal
  end

  def test_zero_quantity
    item = CartItem.new(@product, 0)
    assert_equal BigDecimal("0"), item.subtotal
  end
end
