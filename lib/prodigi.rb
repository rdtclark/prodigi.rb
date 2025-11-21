# frozen_string_literal: true

require "faraday"
require "logger"
require_relative "prodigi/version"

# Ruby client library for the Prodigi Print API
#
# Prodigi provides a worldwide printing and fulfillment service through their API.
# This gem provides a Ruby interface to interact with their API endpoints.
#
# @example Basic usage
#   client = Prodigi::Client.new(api_key: ENV["PRODIGI_API_KEY"])
#   orders = client.orders.list
#   order = client.orders.create(
#     merchantReference: "ref123",
#     shippingMethod: "Overnight",
#     recipient: { name: "John Doe", address: {...} },
#     items: [...]
#   )
#
# @see https://www.prodigi.com/print-api/docs/reference/
# @author Robin Clark
module Prodigi
  autoload :Client, "prodigi/client"
  autoload :Collection, "prodigi/collection"
  autoload :Error, "prodigi/error"
  autoload :Resource, "prodigi/resource"
  autoload :Object, "prodigi/object"

  # High-level categories of Prodigi API calls
  autoload :OrderResource, "prodigi/resources/orders"
  autoload :QuoteResource, "prodigi/resources/quotes"
  autoload :ProductResource, "prodigi/resources/products"

  # Classes used to return a nicer object wrapping the response data
  autoload :Order, "prodigi/objects/order"
  autoload :Quote, "prodigi/objects/quote"
  autoload :Product, "prodigi/objects/product"
end
