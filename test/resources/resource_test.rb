# frozen_string_literal: true

require "test_helper"

class ResourceTest < Minitest::Test
  def test_handles_400_error
    stub = stub_request("test/path",
                        response: [400, { "Content-Type" => "application/json" }, '{"statusText": "Bad Request"}'])
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    resource = Prodigi::Resource.new(client)

    error = assert_raises(Prodigi::Error) do
      resource.get_request("test/path")
    end

    assert_match(/Bad request/, error.message)
  end

  def test_handles_500_error
    stub = stub_request("test/path",
                        response: [500, { "Content-Type" => "application/json" },
                                   '{"statusText": "Internal Server Error"}'])
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    resource = Prodigi::Resource.new(client)

    error = assert_raises(Prodigi::Error) do
      resource.get_request("test/path")
    end
    assert_match(/Internal server error/, error.message)
  end

  def test_patch_request
    body = { test: "data" }
    stub = stub_request("test/path", method: :patch, body: body, response: stub_response(fixture: "orders/retrieve"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    resource = Prodigi::Resource.new(client)

    response = resource.patch_request("test/path", body: body)
    assert_equal 200, response.status
  end

  def test_put_request
    body = { test: "data" }
    stub = stub_request("test/path", method: :put, body: body, response: stub_response(fixture: "orders/retrieve"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    resource = Prodigi::Resource.new(client)

    response = resource.put_request("test/path", body: body)
    assert_equal 200, response.status
  end

  def test_delete_request
    stub = stub_request("test/path", method: :delete, response: stub_response(fixture: "orders/retrieve"))
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, stubs: stub)
    resource = Prodigi::Resource.new(client)

    response = resource.delete_request("test/path")
    assert_equal 200, response.status
  end
end
