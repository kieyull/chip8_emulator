# frozen_string_literal: true

module Chip8
  module Components
    class Memory
      include Chip8::Components::Font

      attr_reader :data

      MEMORY_SIZE = 4096
      PROGRAM_OFFSET = 0x200 # Chip-8 programs start at memory address 0x200 (512)

      def initialize
        @data = Array.new(MEMORY_SIZE, 0x0)
        load_font
      end

      def add_to_memory(addr, val)
        raise ArgumentError.new('Memmory address out of bounds') if addr > MEMORY_SIZE - 1

        data[addr] = val
      end

      def get_data_at(addr)
        data[:addr]
      end

      private

      def load_font
        FONT.each_with_index do |byte, index|
          add_to_memory(FONT_OFFSET + index, byte)
        end
      end
    end
  end
end