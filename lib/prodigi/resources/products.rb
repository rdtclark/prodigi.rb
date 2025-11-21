# frozen_string_literal: true

module Prodigi
  # Resource class for retrieving product information via the Prodigi API
  #
  # Provides methods for fetching details about available products in the
  # Prodigi catalog. Products include information about SKUs, dimensions,
  # attributes, print areas, and shipping destinations.
  #
  # @example Getting product details
  #   product = client.products.details(sku: "GLOBAL-CAN-10X10")
  #   puts product.description
  #   puts product.productDimensions.width
  #   puts product.attributes.wrap
  #
  # @example Checking available attributes
  #   product = client.products.details(sku: "GLOBAL-CAN-10X10")
  #   product.variants.each do |variant|
  #     puts "Ships to: #{variant.shipsTo.join(', ')}"
  #   end
  #
  # @see https://www.prodigi.com/print-api/docs/reference/#products
  class ProductResource < Resource
    def details(sku:)
      response = get_request("products/#{sku}")
      return unless response.body["outcome"] == "Ok"

      Product.new response.body["product"]
    end
  end
end
