# frozen_string_literal: true

module Prodigi
  # Resource class for managing orders via the Prodigi API
  #
  # Provides methods for creating, retrieving, listing, and managing orders.
  # Orders represent print jobs that will be fulfilled by Prodigi's worldwide
  # printing network.
  #
  # @example Listing orders
  #   orders = client.orders.list
  #   orders.data.each do |order|
  #     puts order.id
  #   end
  #
  # @example Creating an order
  #   order = client.orders.create(
  #     merchantReference: "order-123",
  #     shippingMethod: "Overnight",
  #     recipient: {
  #       name: "John Doe",
  #       address: {
  #         line1: "123 Main St",
  #         townOrCity: "New York",
  #         postalOrZipCode: "10001",
  #         countryCode: "US"
  #       }
  #     },
  #     items: [
  #       {
  #         sku: "GLOBAL-CAN-10X10",
  #         copies: 1,
  #         assets: [{ printArea: "default", url: "https://..." }]
  #       }
  #     ]
  #   )
  #
  # @example Updating order metadata
  #   client.orders.update_metadata(
  #     prodigi_order_id: "ord_123",
  #     metadata: { order_source: "website" }
  #   )
  #
  # @see https://www.prodigi.com/print-api/docs/reference/#orders
  class OrderResource < Resource
    def list(**params)
      response = get_request("orders", params: params)
      Collection.from_response(response, key: "orders", type: Order)
    end

    def create(**attributes)
      response = post_request("orders", body: attributes)
      return unless response.body["outcome"] == "Created"

      Order.new response.body["order"]
    end

    def retrieve(prodigi_order_id:)
      response = get_request("orders/#{prodigi_order_id}")
      return unless response.body["outcome"] == "Ok"

      Order.new response.body["order"]
    end

    def actions(prodigi_order_id:)
      response = get_request("orders/#{prodigi_order_id}/actions")
      return unless response.body["outcome"] == "Ok"

      Object.new response.body
    end

    def update_shipping(prodigi_order_id:, **attributes)
      response = post_request("orders/#{prodigi_order_id}/actions/updateShipping",
                              body: attributes)
      return unless response.body["outcome"] == "Updated"

      Order.new response.body["order"]
    end

    def update_recipient(prodigi_order_id:, **attributes)
      response = post_request("orders/#{prodigi_order_id}/actions/updateRecipient",
                              body: attributes)
      return unless response.body["outcome"] == "Updated"

      Order.new response.body["order"]
    end

    def update_metadata(prodigi_order_id:, **attributes)
      response = post_request("orders/#{prodigi_order_id}/actions/updateMetadata", body: attributes)
      return unless response.body["outcome"] == "Updated"

      Order.new response.body["order"]
    end

    def cancel(prodigi_order_id:, **attributes)
      response = post_request("orders/#{prodigi_order_id}/actions/cancel",
                              body: attributes)
      return unless response.body["outcome"] == "Cancelled"

      Order.new response.body["order"]
    end
  end
end
