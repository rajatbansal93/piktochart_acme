require_relative "../test_helper"

class DiscountRuleTest < Minitest::Test
  def setup
    @red_widget = Product.new(sku: "R01", name: "Red Widget", price: BigDecimal("32.95"))
    @green_widget = Product.new(sku: "G01", name: "Green Widget", price: BigDecimal("24.95"))

    @discount_rule = BuyOneGetSecondHalfPrice.new(sku: "R01")
  end

  def test_no_items
    items = []
    assert_equal BigDecimal("0"), @discount_rule.apply(items)
  end

  def test_single_item_no_discount
    items = [CartItem.new(@red_widget, 1)]
    assert_equal BigDecimal("0"), @discount_rule.apply(items)
  end

  def test_two_items_discount_applied
    items = [CartItem.new(@red_widget, 2)]
    expected = BigDecimal("32.95") / BigDecimal("2")
    assert_equal expected, @discount_rule.apply(items)
  end

  def test_three_items_discount_applied_for_one_pair
    items = [CartItem.new(@red_widget, 3)]
    expected = BigDecimal("32.95") / BigDecimal("2")
    assert_equal expected, @discount_rule.apply(items)
  end

  def test_four_items_discount_applied_for_two_pairs
    items = [CartItem.new(@red_widget, 4)]
    expected = BigDecimal("32.95") / BigDecimal("2") * 2
    assert_equal expected, @discount_rule.apply(items)
  end

  def test_multiple_skus_only_target_sku_discounted
    items = [
      CartItem.new(@red_widget, 2),
      CartItem.new(@green_widget, 4)
    ]
    expected = BigDecimal("32.95") / BigDecimal("2")
    assert_equal expected, @discount_rule.apply(items)
  end

  def test_zero_quantity_item
    items = [CartItem.new(@red_widget, 0)]
    assert_equal BigDecimal("0"), @discount_rule.apply(items)
  end
end
