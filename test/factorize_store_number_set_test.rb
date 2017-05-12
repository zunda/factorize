require 'test_helper'
require 'fakeredis/minitest'

class FactorizeStoreNumberSetTest < Minitest::Test

  def setup
    @src = "2, 3, 4, 5, 6"
    def @src.id; return self.intern; end
    @ary = @src.scan(/\d+/).map{|e| Integer(e)}
    _cleanup_redis
  end

  def teardown
    _cleanup_redis
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

  def test_complete
    x = Factorize::Store::NumberSet.new(@src, @ary)
    assert !x.complete?
    @ary.each do |n|
      x.done_with(n)
    end
    assert x.complete?
  end

  def test_synchronize
    x = Factorize::Store::NumberSet.new(@src, @ary)
    y = Factorize::Store::NumberSet.new(@src, @ary)
    assert_equal x.waiting_for.sort, y.waiting_for.sort
    x.done_with(2)
    assert_equal x.waiting_for.sort, y.waiting_for.sort
  end

  def test_forget
    n = Redis.new.keys.length
    x = Factorize::Store::NumberSet.new(@src, @ary)
    assert Redis.new.keys.length > n
    x.forget!
    assert Redis.new.keys.length == n
  end

  def test_fetch
    x = Factorize::Store::NumberSet.new(@src, @ary)
    y = Factorize::Store::NumberSet.fetch(x.source_id)
    assert_equal x.source, y.source
  end

  def _cleanup_redis
    Factorize::Store::NumberSet.new(@src, @ary).forget!
    @ary.each do |n|
      Factorize::Store::Number.new(n).forget!
    end
  end
end
