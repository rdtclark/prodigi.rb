# frozen_string_literal: true

require "test_helper"

class ClientTest < Minitest::Test
  def test_new
    client = Prodigi::Client.new(api_key: "fake", adapter: :test)
    assert_equal Prodigi::Client, client.class
  end

  def test_default_base_url
    client = Prodigi::Client.new(api_key: "fake", adapter: :test)
    assert_equal client.base_url, Prodigi::Client::BASE_URL_DEFAULT
  end

  def test_base_url_override_as_env
    previous = ENV.fetch("PRODIGI_API_URL", nil)
    ENV["PRODIGI_API_URL"] = "https://api.sandbox.prodigi.com/ENV_TEST"

    client = Prodigi::Client.new(api_key: "fake", adapter: :test)
    assert_equal client.base_url, "https://api.sandbox.prodigi.com/ENV_TEST"

    ENV["PRODIGI_API_URL"] = previous
  end

  def test_base_url_override_as_argument
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, base_url: "https://api.sandbox.prodigi.com/ARGUMENT_TEST")
    assert_equal client.base_url, "https://api.sandbox.prodigi.com/ARGUMENT_TEST"
  end

  def test_debug_logging
    client = Prodigi::Client.new(api_key: "fake", adapter: :test, debug: true)
    connection = client.connection

    assert_equal Faraday::Connection, connection.class
  end

  def test_debug_logging_filters_api_key
    output = StringIO.new
    logger = Logger.new(output)

    stub = stub_request("orders", response: stub_response(fixture: "orders/list"))
    client = Prodigi::Client.new(
      api_key: "secret-key-123",
      adapter: :test,
      stubs: stub,
      debug: true,
      logger: logger
    )

    client.orders.list
    log_output = output.string

    assert_includes log_output, "[REMOVED]" if log_output.include?("X-api-key")
  end
end
