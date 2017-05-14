require 'test_helper'
require 'fakeredis/minitest'
require 'prime'

class FactorizeStoreFactorsTest < Minitest::Test
  def setup
    @n = 42
    @f = Prime.prime_division(@n)
    Factorize::Store::Factors.store(@n, @f)
    @m = 43
    Factorize::Store::Factors.forget(@m)
  end

  def teardown
    Factorize::Store::Factors.forget(@n)
  end

  def test_fetch
    assert_equal @f, Factorize::Store::Factors.fetch(@n)
  end

  def test_fetch_miss
    assert_nil Factorize::Store::Factors.fetch(@m)
  end

  def test_forget
    Factorize::Store::Factors.forget(@n)
    assert_nil Factorize::Store::Factors.fetch(@n)
  end
end
