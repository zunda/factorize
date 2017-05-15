require 'test_helper'
require 'fakeredis/minitest'
require 'prime'

class FactorizeStoreNumbersTest < Minitest::Test
  def setup
    @n = 42
    Factorize::Store::Numbers.factorizing(@n)
    @m = 43
    @f = Prime.prime_division(@m)
    Factorize::Store::Numbers.factorizing(@m)
    Factorize::Store::Numbers.factorized(@m, @f)
    @l = 44
    Factorize::Store::Numbers.forget(@l)
  end

  def teardown
    Factorize::Store::Numbers.forget(@n)
    Factorize::Store::Numbers.forget(@m)
  end

  def test_unknown
    assert_nil Factorize::Store::Numbers.factors(@n)
    assert_nil Factorize::Store::Numbers.factors(@l)
  end

  def test_fatorizing
    assert Factorize::Store::Numbers.factorizing?(@n)
    assert !Factorize::Store::Numbers.factorizing?(@m)
    assert !Factorize::Store::Numbers.factorizing?(@l)
  end

  def test_factors
    assert_nil Factorize::Store::Numbers.factors(@n)
    assert_nil Factorize::Store::Numbers.factors(@l)
    assert_equal @f, Factorize::Store::Numbers.factors(@m)
  end

  def test_forget
    Factorize::Store::Numbers.forget(@m)
    assert !Factorize::Store::Numbers.factorizing?(@m)
    Factorize::Store::Numbers.forget(@n)
    assert !Factorize::Store::Numbers.factorizing?(@n)
    assert_nil Factorize::Store::Numbers.factors(@n)
  end
end
