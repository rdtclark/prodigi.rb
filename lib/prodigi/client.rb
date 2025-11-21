# frozen_string_literal: true

module Prodigi
  # Main client for interacting with the Prodigi API
  #
  # The client handles authentication, request configuration, and provides access
  # to all API resources (orders, quotes, products). By default, it connects to
  # the sandbox environment unless configured otherwise.
  #
  # @example Basic client setup
  #   client = Prodigi::Client.new(api_key: "your_api_key")
  #
  # @example Production environment
  #   client = Prodigi::Client.new(
  #     api_key: "your_api_key",
  #     base_url: "https://api.prodigi.com/v4.0"
  #   )
  #
  # @example With debugging enabled
  #   client = Prodigi::Client.new(
  #     api_key: "your_api_key",
  #     debug: true
  #   )
  class Client
    BASE_URL_DEFAULT = "https://api.sandbox.prodigi.com/v4.0"
    BASE_URL_ENV_VAR = "PRODIGI_API_URL"

    attr_reader :api_key, :adapter, :base_url, :debug, :logger

    # Initializes a new Prodigi API client
    #
    # @param api_key [String] Your Prodigi API key (required)
    # @param options [Hash] Optional configuration
    # @option options [Symbol] :adapter Faraday adapter to use (default: Faraday.default_adapter)
    # @option options [String] :base_url Custom API base URL (defaults to sandbox or PRODIGI_API_URL env var)
    # @option options [Faraday::Adapter::Test::Stubs] :stubs Test stubs for mocking requests (for testing only)
    # @option options [Boolean] :debug Enable debug logging (default: false)
    # @option options [Logger] :logger Custom logger instance (default: stdout logger)
    #
    # @example With options
    #   client = Prodigi::Client.new(
    #     api_key: ENV["PRODIGI_API_KEY"],
    #     debug: true,
    #     base_url: "https://api.prodigi.com/v4.0"
    #   )
    def initialize(api_key:, **options)
      @api_key = api_key
      @adapter = options.fetch(:adapter, Faraday.default_adapter)
      @base_url = options[:base_url] || ENV.fetch(BASE_URL_ENV_VAR, BASE_URL_DEFAULT)
      @debug = options.fetch(:debug, false)
      @logger = options[:logger] || Logger.new($stdout).tap do |log|
        log.progname = self.class.name
      end

      # Tests stubs for requests
      @stubs = options[:stubs]
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
        conn.response :json
        configure_debug_logging(conn) if @debug
        conn.adapter adapter, @stubs
      end
    end

    private

    def configure_debug_logging(conn)
      conn.response :logger, @logger do |logger|
        logger.filter(/(X-api-key:)([^&]+)/, '\1[REMOVED]')
      end
    end
  end
end
