module Prodigi
  class QuoteResource < Resource

    def create(**attributes)
      response = post_request("quotes", body: attributes)
      if response.body.dig("outcome") == "Created"
        Quote.new response.body
      end
    end

  end
end
