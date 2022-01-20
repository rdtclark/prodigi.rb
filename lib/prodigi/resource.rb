module Prodigi
  class Resource
    attr_reader :client

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
      message = response.body["statusText"]
      case response.status
      when 400
        raise Error, "Bad request: the request is malformed in some manner. #{message}"
      when 401
        raise Error, "Unauthorised: your credentials are missing or incorrect. #{message}"
      when 403
        raise Error, message
      when 404
        raise Error, "Not found: the resource does not exist (or does not exist in your account). #{message}"
      when 429
        raise Error, message
      when 500
        raise Error, "Internal server error: Please contact support@prodigi.com. #{message}"
      end

      response
    end
  end
end
