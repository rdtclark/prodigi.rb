# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "prodigi"
require "minitest/autorun"
require "faraday"
require "json"
require "minitest/reporters"
# require "pry"

Minitest::Reporters.use!

module Minitest
  class Test
    def stub_response(fixture:, status: 200, headers: { "Content-Type" => "application/json" })
      [status, headers, File.read("test/fixtures/#{fixture}.json")]
    end

    def stub_request(path, response:, method: :get, body: {})
      Faraday::Adapter::Test::Stubs.new do |stub|
        arguments = [method, "/v4.0/#{path}"]
        arguments << body.to_json if %i[post put patch].include?(method)
        stub.send(*arguments) { |_env| response }
      end
    end
  end
end
