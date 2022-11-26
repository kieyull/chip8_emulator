# frozen_string_literal: true

require_relative("chip8/cpu")

module Chip8
  class Emulator
    attr_reader :cpu, :rom_file

    def initialize
      @cpu = CPU.new
    end

    def get_memory
      p cpu.get_memory
    end

    def run(rom)
      cpu.load_rom(rom)
    end
  end
end
