class Catalogue
  def initialize(products = [])
    @products = products.index_by(&:sku)
  end

  def find(sku)
    @products.fetch(sku)
  end
end
