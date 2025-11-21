# frozen_string_literal: true

module Prodigi
  # Represents a paginated collection of resources from the Prodigi API
  #
  # Collections are returned by list endpoints and include pagination information
  # to help traverse large result sets.
  #
  # @example Accessing collection data
  #   orders = client.orders.list
  #   orders.data        #=> [#<Prodigi::Order>, #<Prodigi::Order>, ...]
  #   orders.has_more    #=> true
  #   orders.next_url    #=> "https://api.prodigi.com/v4.0/orders?skip=10"
  #
  # @attr_reader [Array] data The collection of resources
  # @attr_reader [Boolean] has_more Whether more results are available
  # @attr_reader [String, nil] next_url URL to fetch the next page of results
  class Collection
    attr_reader :data, :has_more, :next_url

    # Creates a Collection from an API response
    #
    # @param response [Faraday::Response] The HTTP response from the API
    # @param key [String] The JSON key containing the array of resources
    # @param type [Class] The class to instantiate for each resource (e.g., Prodigi::Order)
    # @return [Prodigi::Collection] A new collection instance
    #
    # @example
    #   Collection.from_response(response, key: "orders", type: Order)
    def self.from_response(response, key:, type:)
      body = response.body
      new(
        data: body[key].map { |attrs| type.new(attrs) },
        has_more: body["hasMore"],
        next_url: body["nextUrl"]
      )
    end

    # Initializes a new Collection
    #
    # @param data [Array] The collection of resource objects
    # @param has_more [Boolean] Whether additional pages exist
    # @param next_url [String, nil] The URL for the next page of results
    def initialize(data:, has_more:, next_url:)
      @data = data
      @has_more = has_more
      @next_url = @has_more == true ? next_url : nil
    end
  end
end
