require 'test_helper'
require 'fakeredis/minitest'

class FactorizeStoreNumberTest < Minitest::Test
  def setup
    @n = 42
    @x= Factorize::Store::Number.new(@n)
    @x.factorize!
  end

  def teardown
    @x.forget!
  end

  def test_factorize
    assert_equal Prime.prime_division(@n), @x.factorize!
    assert_equal Prime.prime_division(@n), @x.factors
  end

  def test_persistent_factors
    y= Factorize::Store::Number.new(@n)
    assert_equal Prime.prime_division(@n), y.factors
  end

  def test_to_forget
    @x.forget!
    assert_nil @x.factors
  end

  def test_state
    assert_equal 2, @x.state
    @x.forget!
    assert_equal 0, @x.state
  end
end
