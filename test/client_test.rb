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
end
