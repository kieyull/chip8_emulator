# frozen_string_literal: true

module Chip8
  module Components
    class Clock
      def initialize
        @clock_speed = 0 # TODO: Set this correctly
        @delay_timer = 0 # 8-bit
        @sound_timer = 0 # 8-bit
      end
    end
  end
end
