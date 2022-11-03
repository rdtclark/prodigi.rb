module Prodigi
  class Client
    BASE_URL_DEFAULT = "https://api.sandbox.prodigi.com/v4.0"
    BASE_URL_ENV_VAR = "PRODIGI_API_URL"

    attr_reader :api_key, :adapter, :base_url

    def initialize(api_key:, adapter: Faraday.default_adapter, base_url: nil, stubs: nil)
      @api_key = api_key
      @adapter = adapter
      @base_url = base_url || ENV.fetch(BASE_URL_ENV_VAR, BASE_URL_DEFAULT)

      # Tests stubs for requests
      @stubs = stubs
    end

    def orders
      OrderResource.new(self)
    end

    def quotes
      QuoteResource.new(self)
    end

    def products
      ProductResource.new(self)
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = @base_url
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter, @stubs
      end
    end
  end
end
