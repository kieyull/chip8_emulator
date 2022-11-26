# frozen_string_literal: true

module Chip8
  module Components
    class ProgramCounter
      attr_reader :index

      def initialize(starting_index)
        @index = starting_index
      end

      def increment
        index += 1 if index < Memory::MEMORY_SIZE
      end

      def update_pointer(addr)
        index = addr
      end
    end
  end
end
