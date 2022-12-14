# frozen_string_literal: true

module Chip8
  module Components
    class Stack
      attr_reader :data, :pointer

      STACK_SIZE = 0xC # 12

      def initialize
        @data = Array.new
      end

      def push(val)
        raise ArgumentError.new('No room on the stack') if data.size >= STACK_SIZE
 
        data.unshift(val)
      end

      def pop
        raise ArgumentError.new('Stack is empty') if data.blank?

        data.delete_at(0)
      end
    end
  end
end