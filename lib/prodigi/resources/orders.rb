module Prodigi
  class OrderResource < Resource

    def list(**params)
      response = get_request("orders", params: params)
      Collection.from_response(response, key: "orders", type: Order)
    end

    def create(**attributes)
      res = post_request("orders", body: attributes ).body.dig("order")
      if res.body.dig("outcome") == "Created"
        Order.new res.body.dig("order")
      end
    end

    def retrieve(prodigi_order_id:)
      res = get_request("orders/#{prodigi_order_id}")
      if res.body.dig("outcome") == "Updated"
        Order.new res.body.dig("order")
      end
    end

    def actions(prodigi_order_id:)
      Object.new get_request("orders/#{prodigi_order_id}/actions").body
    end

    def update_shipping(prodigi_order_id:, **attributes)
      res = post_request("orders/#{prodigi_order_id}/actions/updateShipping", body: attributes)
      if res.body.dig("outcome") == "Updated"
        Order.new res.body.dig("order")
      end
    end 

    def update_recipient(prodigi_order_id:, **attributes)
      res = post_request("orders/#{prodigi_order_id}/actions/updateRecipient", body: attributes)
      if res.body.dig("outcome") == "Updated"
        Order.new res.body.dig("order")
      end
    end 

    def update_metadata(prodigi_order_id:, **attributes)
      res = post_request("orders/#{prodigi_order_id}/actions/updateMetadata", body: attributes)
      if res.body.dig("outcome") == "Updated"
        Order.new res.body.dig("order")
      end
    end 

    def cancel(prodigi_order_id:, **attributes)
      post_request("orders/#{prodigi_order_id}/actions/cancel", body: attributes).body.dig("outcome")
    end 

  end
end
