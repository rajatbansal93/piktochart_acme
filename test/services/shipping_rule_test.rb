require_relative "../test_helper"

class ShippingRuleTest < Minitest::Test
  def setup
    @tiered = TieredShippingRule.new(
      thresholds: [
        { limit: BigDecimal("90"), cost: BigDecimal("0") },
        { limit: BigDecimal("50"), cost: BigDecimal("2.95") },
        { limit: BigDecimal("0"), cost: BigDecimal("4.95") }
      ]
    )
  end

  def test_free_shipping_exact_limit
    assert_equal BigDecimal("0"), @tiered.calculate(BigDecimal("90"))
  end

  def test_shipping_zero_subtotal
    assert_equal BigDecimal("4.95"), @tiered.calculate(BigDecimal("0"))
  end
end
