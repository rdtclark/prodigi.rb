module Prodigi
  class ProductResource < Resource

    def details(sku:)
      response = get_request("products/#{sku}")
      if response.body.dig("outcome") == "Ok"
        Product.new response.body.dig("product")
      end
    end

  end
end
