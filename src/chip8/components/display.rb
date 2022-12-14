# frozen_string_literal: true

require 'gosu'

module Chip8
  module Components
    class Display < Gosu::Window
      attr_reader :display_buffer
      WIDTH = 64
      HEIGHT = 32
      SCALE = 10
      EMPTY_BUFFER = Array.new(WIDTH) { Array.new(HEIGHT, 0) }

      def initialize(rom_name = 'Chip-8')
        super WIDTH * SCALE, HEIGHT * SCALE
        self.caption = rom_name
        @display_buffer = clear_screen
      end

      def update
      end

      def draw
        # Draw the display buffer to the screen
      end

      def clear_screen
        @display_buffer = EMPTY_BUFFER
      end

      def update_display_buffer(new_buffer)
        @display_buffer = new_buffer
      end
    end
  end
end
