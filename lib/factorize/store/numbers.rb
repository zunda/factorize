require 'redis-objects'
require "factorize/store/factors"

module Factorize
  module Store
    class Numbers
      REDIS_KEY = 'factorize_store_numbers'
      @@set = Redis::Set.new(REDIS_KEY)

      def Numbers.factors(n)
        Factors.fetch(n)
      end

      def Numbers.factorizing(n)
        @@set.add(n)
      end

      def Numbers.factorizing?(n)
        @@set.member?(n)
      end

      def Numbers.factorized(n, f)
        # TODO: remove possible race condition
        Factors.store(n, f)
        @@set.delete(n)
      end

      def Numbers.forget(n)
        @@set.delete(n)
      end
    end
  end
end
