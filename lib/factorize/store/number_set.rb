require 'redis-objects'

module Factorize
  module Store
    class NumberSet
      include Redis::Objects
      value :source_store
      set :waiting_for_store
      redis_id_field :source_id

      attr_reader :source_id

      def NumberSet.fetch(source_id)
        source_object = NumberSet.redis.get(source_id)
        numbers = NumberSet.redis.get(source_id)
        NumberSet.new(source_object, numbers)
      end

      def initialize(source_object, numbers)
        @source_id = source_object.id
        source_store.value = source_object
        numbers.each do |n|
          waiting_for_store.add(n) unless Number.new(n).factors
        end
      end


      def waiting_for
        return waiting_for_store.get.map{|e| Integer(e)}
      end

      def source_object
        return source_store.value
      end

      def done_with(number)
        waiting_for_store.delete(number)
      end

      def complete?
        waiting_for_store.empty?
      end

      def forget!
        waiting_for_store.get.each do |n|
          waiting_for_store.delete(n)
        end
        source_store.delete
      end
    end
  end
end
