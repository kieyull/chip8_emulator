# frozen_string_literal: true

require 'gosu'

module Chip8
  module Components
    class Display < Gosu::Window
      def initialize
        super 64, 32
        self.caption = 'Chip8'
      end

      def update
      end

      def draw
      end
    end
  end
end
