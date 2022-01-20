module Prodigi
  class Client 
    BASE_URL = "https://api.sandbox.prodigi.com/v4.0"

    attr_reader :api_key, :adapter

    def initialize(api_key:, adapter: Faraday.default_adapter, stubs: nil)
      @api_key = api_key
      @adapter = adapter

      # Tests stubs for requests
      @stubs = stubs
    end

    def orders
      OrderResource.new(self)
    end

    def quote
    end

    def connection
      @connection ||= Faraday.new do |conn|
        conn.url_prefix = BASE_URL
        conn.request :json
        conn.response :json, content_type: "application/json"
        conn.adapter adapter, @stubs
      end
    end
  end
end
