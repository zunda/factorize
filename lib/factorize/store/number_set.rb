require 'redis-objects'

module Factorize
  module Store
    class NumberSet
      def NumberSet.key(id, field)
        "number_set:#{id}:#{field}"
      end
      include Redis::Objects
      value :source_store, :key => NumberSet.key('#{id}', 'source_store')
      set :waiting_for_store, :key => NumberSet.key('#{id}', 'waiting_for_store')
      redis_id_field :source_id

      attr_reader :source_id

      def NumberSet.fetch(source_id)
        source_object = NumberSet.redis.get(NumberSet.key(source_id, 'source_store'))
        numbers = NumberSet.redis.smembers(NumberSet.key(source_id, 'waiting_for_store')).map {|e| Integer(e)}
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
