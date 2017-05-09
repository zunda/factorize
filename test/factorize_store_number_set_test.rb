require 'test_helper'
require 'fakeredis'

class FactorizeStoreNumberSetTest < Minitest::Test
  def setup
    @src = "2, 3, 4, 5, 6"
    def @src.id; return self.intern; end
    @ary = @src.scan(/\d+/).map{|e| Integer(e)}
    @ary.each do |n|
      Factorize::Store::Number.new(n).forget!
    end
  end

  def test_initialize_without_cache
    x = Factorize::Store::NumberSet.new(@src, @ary)
    assert_equal @src, x.source_object
    assert_equal @ary.sort, x.waiting_for.sort
  end

  def test_initialize_with_some_cache
    factorized = [2, 4, 5]
    factorized.each do |n|
      Factorize::Store::Number.new(n).factorize!
    end
    x = Factorize::Store::NumberSet.new(@src, @ary)
    assert_equal (@ary - factorized).sort, x.waiting_for.sort
  end

  def test_done_with
    x = Factorize::Store::NumberSet.new(@src, @ary)
    x.done_with(5)
    assert_equal (@ary - [5]).sort, x.waiting_for.sort
  end
end
