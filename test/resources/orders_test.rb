# frozen_string_literal: true
require "json"
require "test_helper"

class OrdersResourceTest < Minitest::Test
  def test_list
    stub = stub_request("orders", response: stub_response(fixture: "orders/list"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    orders = client.orders.list

    assert_equal Prodigi::Collection, orders.class
    assert_equal Prodigi::Order, orders.data.first.class
  end

  def test_create
    file = File.read("test/fixtures/orders/requests/create.json")
    body = JSON.parse(file)
    stub = stub_request("orders", method: :post, body: body, response: stub_response(fixture: "orders/create", status: 200))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    order = client.orders.create(**body)

    assert_equal Prodigi::Order, order.class
    assert_equal"MyMerchantReference1", order["merchantReference"]
  end 

  def test_actions
  end

  def test_update_shipping
  end

  def test_update_recipient
  end

  def test_update_metadata
  end

  def test_cancel
  end

end
