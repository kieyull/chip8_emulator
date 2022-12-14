# frozen_string_literal: true

module Chip8
  module Components
    class Clock
      attr_reader :delay_timer, :sound_timer
      def initialize
        @clock_speed = 0 # TODO: Set this correctly
        @delay_timer = 0 # 8-bit
        @sound_timer = 0 # 8-bit
      end

      def set_delay_timer(val)
        delay_timer = val
      end

      def set_sound_timer(val)
        sound_timer = val
      end
    end
  end
end
