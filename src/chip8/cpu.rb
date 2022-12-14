# frozen_string_literal: true

require_relative('components')

module Chip8
  class CPU
    include Chip8::Components

    attr_reader :memory, :pc, :display

    def initialize
      @display = Display.new
      @memory = Memory.new
      @pc = ProgramCounter.new(Memory::PROGRAM_OFFSET)
      @register = Register.new
      @keyboard = Keyboard.new
      @clock = Clock.new
      @stack = Stack.new
      @current_opcode = nil
      @nibbles = {
        instruction: nil,
        x: nil,
        y: nil,
        n: nil,
        nn: nil,
        nnn: nil
      }
    end

    def dump_memory
      memory.data
    end

    def load_rom(rom_file)
      # bytecode = File.read(rom_file).unpack('C*') # 8-bit integer values
      bytecode = File.read(rom_file).unpack('n*') # 16-bit integer values (the size chip-8 expects)

      bytecode.each_with_index do |opcode, index|
        memory.add_to_memory(Memory::PROGRAM_OFFSET + index, opcode)
      end
    end

    def run
      display.show
    end

    def cpu_cycle
      fetch
      decode
      execute
    end

    private

    def fetch
      @current_opcode = memory.get_data_at(pc.index)
      pc.increment
    end

    def execute
      Instructions.execute(nibbles, @display, @keyboard, @memory, @pc, @register, @stack, @clock)
    end

    def decode(opcode)
      @nibbles = {
        instruction: opcode >> 12, # Upper 4 bits of the high byte. Determines what the opcode does    (1111000000000000)
        x:   opcode >> 8 & 0x0F, # A 4-bit value, the lower 4 bits of the high byte of the instruction (0000111100000000)
        y:   opcode >> 4 & 0x0F, # A 4-bit value, the upper 4 bits of the low byte of the instruction  (0000000011110000)
        n:   opcode & 0x0F, # A 4-bit value, the lowest 4 bits of the instruction                      (0000000000001111)
        nn:  opcode & 0xFF, # An 8-bit value, the lowest 8 bits of the instruction                     (0000000011111111)
        nnn: opcode & 0x0FFF # A 12-bit value, the lowest 12 bits of the instruction                   (0000111111111111)
      }
    end
  end
end
