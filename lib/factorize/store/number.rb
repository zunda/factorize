require 'redis-objects'
require 'prime'

module Factorize
  module Store
    class Number
      include Redis::Objects
      value :cached_factors
      value :state  # 0:new 1:factorizing 2:factorized
      redis_id_field :number

      attr_reader :number
      def initialize(number)
        @number = number
        @factors = nil
        @state = 0
      end

      def factorize!
        unless @factors
          @state = 1
          @factors = Prime.prime_division(@number)
          self.cached_factors.value = Marshal::dump(@factors)
          @state = 2
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
        @state = 0
        @factors = nil
        self.cached_factors.delete
      end
    end
  end
end
