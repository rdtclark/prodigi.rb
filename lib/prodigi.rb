# frozen_string_literal: true
require "faraday"
require "faraday_middleware"
require_relative "prodigi/version"

module Prodigi
  autoload :Client, "prodigi/client"
  autoload :Error, "prodigi/error"
end
