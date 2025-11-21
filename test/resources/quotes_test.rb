# frozen_string_literal: true

require "test_helper"

class QuotesResourceTest < Minitest::Test
  def test_create
    body = JSON.parse(File.read("test/fixtures/quotes/requests/create.json"))
    stub = stub_request("quotes", method: :post, body:, response: stub_response(fixture: "quotes/create", status: 200))
    client = Prodigi::Client.new(api_key: "fake",
                                 adapter: :test,
                                 stubs: stub)
    quote = client.quotes.create(**body)

    assert_equal Prodigi::Quote, quote.class
    assert_equal Array, quote.quotes.class
    assert_equal Array, quote.quotes.class
  end
end
