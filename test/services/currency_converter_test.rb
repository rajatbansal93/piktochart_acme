require_relative "../test_helper"

class CurrencyConverterTest < Minitest::Test
  def setup
    @converter = CurrencyConverter.new({ "USD_EUR" => 0.91, "EUR_USD" => 1.1 })
  end

  def test_same_currency
    assert_equal BigDecimal("10"), @converter.convert(BigDecimal("10"), from: "USD", to: "USD")
  end

  def test_nonexistent_rate
    assert_raises(KeyError) { @converter.convert(BigDecimal("10"), from: "USD", to: "INR") }
  end

  def test_usd_to_eur_conversion
    assert_equal BigDecimal("0.91"), @converter.convert(BigDecimal("1"), from: "USD", to: "EUR")
  end
end
