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

  def test_retrieve
    order_id = "ord_840797"
    stub = stub_request("orders/#{order_id}", response: stub_response(fixture: "orders/retrieve"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    order = client.orders.retrieve(prodigi_order_id: order_id)

    assert_equal Prodigi::Order, order.class
    assert_equal"MyMerchantReference1", order["merchantReference"]
  end

  def test_actions
    order_id = "ord_840797"
    stub = stub_request("orders/#{order_id}/actions", response: stub_response(fixture: "orders/actions/actions"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    actions = client.orders.actions(prodigi_order_id: order_id)

    assert_equal Prodigi::Object, actions.class
    assert_equal"Yes", actions.cancel["isAvailable"]
  end

  def test_cancel
    order_id = "ord_840797"
    stub = stub_request("orders/#{order_id}/actions/cancel", 
                        method: :post,
                        response: stub_response(fixture: "orders/actions/cancel"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    order = client.orders.cancel(prodigi_order_id: order_id)

    assert_equal Prodigi::Order, order.class
    assert_equal"Cancelled", order.status.stage
  end

  def test_update_shipping
    order_id = "ord_840799"
    body = { "shippingMethod": "Budget" }
    stub = stub_request("orders/#{order_id}/actions/updateShipping",
                        method: :post,
                        body: body,
                        response: stub_response(fixture: "orders/actions/update_shipping"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    order = client.orders.update_shipping(prodigi_order_id: order_id, **body)

    assert_equal Prodigi::Order, order.class
    assert_equal"Budget", order["shippingMethod"]
  end

  def test_update_recipient
    file = File.read("test/fixtures/orders/requests/update_recipient.json")
    body = JSON.parse(file)
    order_id = "ord_840799"
    stub = stub_request("orders/#{order_id}/actions/updateRecipient",
                        method: :post,
                        body: body,
                        response: stub_response(fixture: "orders/actions/update_recipient"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    order = client.orders.update_recipient(prodigi_order_id: order_id, **body)

    assert_equal Prodigi::Order, order.class
    assert_equal"Mr. Jeff Testing", order.recipient["name"]
    assert_equal"jeff.testing@test.co.uk", order.recipient.email
  end

  def test_update_metadata
    file = File.read("test/fixtures/orders/requests/update_metadata.json")
    body = JSON.parse(file)
    order_id = "ord_840799"
    stub = stub_request("orders/#{order_id}/actions/updateMetadata",
                        method: :post,
                        body: body,
                        response: stub_response(fixture: "orders/actions/update_metadata"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    order = client.orders.update_metadata(prodigi_order_id: order_id, **body)

    assert_equal Prodigi::Order, order.class
    assert_equal"some message", order.metadata.feedback.message
    assert_equal"abdef", order.metadata['internalRef']
  end
end
