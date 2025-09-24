require "bigdecimal"

class CurrencyConverter
  def initialize(rates)
    # rates: { "USD_EUR" => 0.91, "USD_INR" => 83.0 }
    @rates = rates
  end

  def convert(amount, from:, to:)
    return amount if from == to
    key = "#{from}_#{to}"
    rate = @rates.fetch(key)
    (amount * BigDecimal(rate.to_s)).round(2)
  end
end
