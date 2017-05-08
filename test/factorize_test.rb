require 'test_helper'
require 'fakeredis'

class FactorizeTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Factorize::VERSION
  end

  def test_that_fakeredis_is_available
    assert Redis.new
  end
end
