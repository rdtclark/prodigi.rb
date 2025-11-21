# frozen_string_literal: true

module Prodigi
  # Resource class for creating price quotes via the Prodigi API
  #
  # Provides methods for generating cost estimates for orders before they are
  # created. Quotes include itemized costs, shipping costs, and fulfillment
  # location information.
  #
  # @example Creating a quote
  #   quote = client.quotes.create(
  #     shippingMethod: "Budget",
  #     destinationCountryCode: "GB",
  #     currencyCode: "GBP",
  #     items: [
  #       {
  #         sku: "GLOBAL-CAN-10X10",
  #         copies: 5,
  #         attributes: { wrap: "ImageWrap" },
  #         assets: [{ printArea: "default" }]
  #       }
  #     ]
  #   )
  #
  # @example Accessing quote details
  #   quote = client.quotes.create(...)
  #   quote.quotes.each do |q|
  #     puts "Shipping: #{q.costSummary.shipping.amount} #{q.costSummary.shipping.currency}"
  #     puts "Items: #{q.costSummary.items.amount} #{q.costSummary.items.currency}"
  #   end
  #
  # @see https://www.prodigi.com/print-api/docs/reference/#quotes
  class QuoteResource < Resource
    def create(**attributes)
      response = post_request("quotes", body: attributes)
      return unless response.body["outcome"] == "Created"

      Quote.new response.body
    end
  end
end
