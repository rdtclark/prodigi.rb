# frozen_string_literal: true

require_relative "error"

module Prodigi
  # Base class for all API resource classes
  #
  # Provides common HTTP request methods (GET, POST, PATCH, PUT, DELETE) and
  # response handling for interacting with the Prodigi API. All specific resource
  # classes (OrderResource, QuoteResource, ProductResource) inherit from this class.
  #
  # This class handles:
  # - HTTP request construction with proper headers
  # - Response parsing and error handling
  # - Debug logging when enabled
  # - Authentication via API key headers
  #
  # @abstract Subclass and add resource-specific methods
  # @attr_reader [Prodigi::Client] client The API client instance
  #
  # @example Subclassing (internal use)
  #   class OrderResource < Resource
  #     def list(**params)
  #       response = get_request("orders", params: params)
  #       Collection.from_response(response, key: "orders", type: Order)
  #     end
  #   end
  class Resource
    attr_reader :client

    ERROR_MAP = {
      400 => [BadRequestError, "Bad request: the request is malformed."],
      401 => [UnauthorizedError, "Unauthorised: credentials missing or incorrect."],
      403 => [ForbiddenError, nil],
      404 => [NotFoundError, "Resource does not exist."],
      429 => [RateLimitError, nil]
    }.freeze

    def initialize(client)
      @client = client
    end

    def get_request(url, params: {}, headers: {})
      handle_response client.connection.get(url, params, default_headers.merge(headers))
    end

    def post_request(url, body:, headers: {})
      handle_response client.connection.post(url, body, default_headers.merge(headers))
    end

    def patch_request(url, body:, headers: {})
      handle_response client.connection.patch(url, body, default_headers.merge(headers))
    end

    def put_request(url, body:, headers: {})
      handle_response client.connection.put(url, body, default_headers.merge(headers))
    end

    def delete_request(url, params: {}, headers: {})
      handle_response client.connection.delete(url, params, default_headers.merge(headers))
    end

    def default_headers
      { "X-API-Key": client.api_key }
    end

    def handle_response(response)
      client.logger.debug(response.pretty_inspect) if client.debug

      raise_error_if_needed(response)

      response
    end

    private

    def raise_error_if_needed(response)
      status = response.status
      message = response.body["statusText"]

      if ERROR_MAP.key?(status)
        error_class, prefix = ERROR_MAP[status]
        full_message = prefix ? "#{prefix} #{message}" : message
        raise error_class, full_message
      elsif status.between?(500, 599)
        raise ServerError, "Internal server error. #{message}"
      end
    end
  end
end
