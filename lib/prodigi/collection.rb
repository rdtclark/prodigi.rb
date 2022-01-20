module Prodigi
  class Collection
    attr_reader :data, :has_more, :next_url

    def self.from_response(response, key:, type:)
      body = response.body
      new(
        data: body[key].map { |attrs| type.new(attrs) },
        has_more: body.dig("hasMore"),
        next_url: body.dig("nextUrl")
      )
    end

    def initialize(data:, has_more:, next_url:)
      @data = data
      @has_more = has_more
      if @has_more == true; @next_url = next_url else @next_url = nil end
    end
  end
end
