require "ostruct"

# class String
#   def underscore
#     self.gsub(/::/, '/').
#       gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
#       gsub(/([a-z\d])([A-Z])/,'\1_\2').
#       tr("-", "_").
#       downcase
#   end
# end

module Prodigi
  # class Object
  #   def initialize(attributes)
  #     # @attributes = OpenStruct.new(attributes.transform_keys! { |key| key.to_s.underscore })
  #     @attributes = OpenStruct.new(attributes)
  #   end

  #   def method_missing(method, *args, &block)
  #     attribute = @attributes.send(method, *args, &block)
  #     attribute.is_a?(Hash) ? Object.new(attribute) : attribute
  #   end

  #   def respond_to_missing?(method, include_private = false)
  #     true
  #   end
  # end
  class Object < OpenStruct
    def initialize(attributes)
      super to_ostruct(attributes)
    end

    def to_ostruct(obj)
      if obj.is_a?(Hash)
        OpenStruct.new(obj.map { |key, val| [key, to_ostruct(val)] }.to_h)
      elsif obj.is_a?(Array)
        obj.map { |o| to_ostruct(o) }
      else # Assumed to be a primitive value
        obj
      end
    end
  end
end
