# frozen_string_literal: true

module Chip8
  module Components
    class Register
      attr_reader :data, :index

      DATA_SIZE = 0x10 # 16

      def initialize
        @data = Array.new(DATA_SIZE, nil)
        @index = nil
      end

      def set_value(location, value)
        raise ArgumentError.new('Location out of bounds') if out_of_bounds

        data[location] = value
      end

      def get_value(location)
        raise ArgumentError.new('Location out of bounds') if out_of_bounds

        data[location]
      end

      def set_index(addr)
        index = addr
      end

      private

      def out_of_bounds(location)
        location > DATA_SIZE || location < 0
      end
    end
  end
end