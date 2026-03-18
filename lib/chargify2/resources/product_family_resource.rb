module Chargify2
  class ProductFamilyResource < Resource
    def self.path
      'product_families'
    end

    def self.representation
      ProductFamily
    end
  end
end
