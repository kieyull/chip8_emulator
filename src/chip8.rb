# frozen_string_literal: true

require_relative("chip8/cpu")

module Chip8
  class Emulator
    attr_reader :cpu, :rom_file

    def initialize
      @cpu = CPU.new
    end

    def dump_memory
      p cpu.dump_memory
    end

    def run(rom)
      cpu.load_rom(rom)
      cpu.run
    end
  end
end
