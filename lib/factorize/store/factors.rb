require 'redis-objects'

module Factorize
  module Store
    class Factors
      def Factors.store(n, factors)
        Factors.new(n).store(factors)
      end

      def Factors.fetch(n)
          return Factors.new(n).fetch
      end

      def Factors.forget(n)
        Factors.new(n).forget!
      end

      include Redis::Objects
      redis_id_field :n
      value :factors
      attr_reader :n

      :private
      def initialize(n)
        @n = n
      end

      def store(factors)
        self.factors.value = Marshal::dump(factors)
      end

      def fetch
        f = self.factors.value
        if f
          return Marshal::load(f)
        end
        return nil
      end

      def forget!
        self.factors.delete
      end
    end
  end
end
