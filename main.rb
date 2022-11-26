require('pry')
require_relative('src/chip8.rb')

rom_file = "#{__dir__}/roms/INVADERS"
chip8 = Chip8::Emulator.new
chip8.run(rom_file)
chip8.get_memory