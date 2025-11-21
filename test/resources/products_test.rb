# frozen_string_literal: true

require "test_helper"

class ProductsResourceTest < Minitest::Test
  def test_details
    sku = "GLOBAL-CAN-10X10"
    stub = stub_request("products/#{sku}", response: stub_response(fixture: "products/details"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    product = client.products.details(sku: sku)

    assert_equal Prodigi::Product, product.class
    assert_equal "Standard canvas on quality stretcher bar, 25x25cm", product.description
  end
end
