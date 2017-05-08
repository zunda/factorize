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
        @factors = Prime.prime_division(@number)
        self.cached_factors = Marshal::dump(@factors)
      end

      def factors
        return @factors || Marshal::load(self.cached_factors)
      end
    end
  end
end
