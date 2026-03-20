module Chargify2
  class ProductFamilyResource < Resource
    def self.path
      'product_families'
    end

    def self.representation
      ProductFamily
    end

    def self.plural_name
      'product_families'
    end
  end
end
