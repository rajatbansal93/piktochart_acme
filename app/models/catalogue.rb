class Catalogue
  def initialize(products = [])
    @products = products.map { |p| [p.sku, p] }.to_h
  end

  def find(sku)
    @products[sku]
  end
end
