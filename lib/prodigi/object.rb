# frozen_string_literal: true

require "ostruct"

module Prodigi
  # Base object class for wrapping API responses
  #
  # Converts Hash and Array responses into OpenStruct objects for convenient
  # dot-notation access to attributes. Recursively processes nested structures.
  #
  # @example Accessing nested attributes
  #   order = Prodigi::Order.new({ id: "ord_123", recipient: { name: "Robin" } })
  #   order.id          #=> "ord_123"
  #   order.recipient.name #=> "Robin"
  class Object < OpenStruct
    # Initializes a new Prodigi object
    #
    # @param attributes [Hash, Array, Object] The attributes to convert
    def initialize(attributes)
      super(to_ostruct(attributes))
    end

    # Recursively converts hashes and arrays to OpenStruct objects
    #
    # @param obj [Hash, Array, Object] The object to convert
    # @return [OpenStruct, Array, Object] The converted object
    def to_ostruct(obj)
      if obj.is_a?(Hash)
        OpenStruct.new(obj.transform_values { |val| to_ostruct(val) })
      elsif obj.is_a?(Array)
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end
  end
end
