# frozen_string_literal: true

module Chip8
  module Components
    class Keyboard
      attr_reader :register

      KEY_MAP = {
        # Keyboard key => Chip-8 key
        Gosu::KB_1 => 0x1,
        Gosu::KB_2 => 0x2,
        Gosu::KB_3 => 0x3,
        Gosu::KB_4 => 0xC,
        Gosu::KB_Q => 0x4,
        Gosu::KB_W => 0x5,
        Gosu::KB_E => 0x6,
        Gosu::KB_R => 0xD,
        Gosu::KB_A => 0x7,
        Gosu::KB_S => 0x8,
        Gosu::KB_D => 0x9,
        Gosu::KB_F => 0xE,
        Gosu::KB_Z => 0xA,
        Gosu::KB_X => 0x0,
        Gosu::KB_C => 0xB,
        Gosu::KB_V => 0xF
      }.freeze

      def initialize
        @register = Array.new(KEY_MAP.size, 0x0)
      end

      def press(key)
        pos = KEY_MAP.fetch(key, nil)
        register[pos] = 1
      end

      def register_key_event(key)
        pos = KEY_MAP.fetch(key, nil)
        return if pos.nil?

        key_state = register[pos].positive? ? 0 : 1
        register[pos] = key_state
      end

      def key_pressed?
       register.include?(1)
      end

      def get_pressed_key
        register.find_index(1)
      end
    end
  end
end
