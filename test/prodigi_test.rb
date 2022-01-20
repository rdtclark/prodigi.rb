# frozen_string_literal: true

require "test_helper"

class ProdigiTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Prodigi::VERSION
  end
end
