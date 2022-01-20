# frozen_string_literal: true

require "test_helper"

class OrdersResourceTest < Minitest::Test
  def test_list
    stub = stub_request("orders", response: stub_response(fixture: "orders/list"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    orders = client.orders.list

    assert_equal Prodigi::Collection, orders.class
    assert_equal Prodigi::Order, orders.data.first.class
  end
end
