require_relative "../test_helper"

class CatalogueTest < Minitest::Test
  def setup
    @products = [
      Product.new(sku: "R01", name: "Red Widget", price: BigDecimal("32.95")),
      Product.new(sku: "G01", name: "Green Widget", price: BigDecimal("24.95"))
    ]
    @catalogue = Catalogue.new(@products)
  end

  def test_lookup_existing_sku
    assert_equal @products.first, @catalogue.find("R01")
  end

  def test_lookup_nonexistent_sku
    assert_nil @catalogue.find("X99")
  end

  def test_empty_catalogue
    empty_catalogue = Catalogue.new([])
    assert_nil empty_catalogue.find("R01")
  end
end
