# frozen_string_literal: true

module Chip8
  module Components
    class Register
      attr_reader :data, :address

      DATA_SIZE = 0x10 # 16

      def initialize
        @data = Array.new(DATA_SIZE, nil)
        @address = nil
      end
    end
  end
end