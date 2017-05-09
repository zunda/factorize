require 'redis-objects'
require 'prime'

module Factorize
  module Store
    class Number
      include Redis::Objects
      value :cached_factors
      redis_id_field :number

      attr_reader :number
      def initialize(number)
        @number = number
        @factors = nil
      end

      def factorize!
        unless @factors
          @factors = Prime.prime_division(@number)
          self.cached_factors.value = Marshal::dump(@factors)
        end
        return @factors
      end

      def factors
        return @factors if @factors
        x = self.cached_factors.value
        return @factors = Marshal::load(x) if x
        return nil
      end

      def forget!
        @factors = nil
        self.cached_factors.delete
      end
    end
  end
end
