# frozen_string_literal: true

require_relative('display')

module Chip8
  module Components
    class Instructions
      class << self
        def execute(nibbles, display, keyboard, memory, pc, register, stack, clock)
          case nibbles[:instruction] 
          when 0
            case opcode & 0x0FFF
            when 0x0E0
              ins_00E0(display)
            when 0x0EE
              ins_00EE(pc, stack)
            end
          when 1
            ins_1nnn(pc, nibbles[:nnn])
          when 2
            ins_2nnn(nibbles[:nnn], stack, pc)
          when 3
            ins_3xnn(nibbles[:x], nibbles[:nn], pc)
          when 4
            ins_4xnn(nibbles[:x], nibbles[:nn], register, pc)
          when 5
            ins_5xy0(nibbles[:x], nibbles[:y], register, pc)
          when 6
            ins_6xnn(nibbles[:x], nibbles[:nn], register)
          when 7
            ins_7xnn(nibbles[:x], nibbles[:nn], register)
          when 8
            case opcode & 0x0F
            when 0
              ins_8xy0(nibbles[:x], nibbles[:y], register)
            when 1
              ins_8xy1(nibbles[:x], nibbles[:y], register)
            when 2
              ins_8xy2(nibbles[:x], nibbles[:y], register)
            when 3
              ins_8xy3(nibbles[:x], nibbles[:y], register)
            when 4
              ins_8xy4(nibbles[:x], nibbles[:y], register)
            when 5
              ins_8xy5(nibbles[:x], nibbles[:y], register)
            when 6
              ins_8xy6(nibbles[:x], nibbles[:y], register)
            when 7
              ins_8xy7(nibbles[:x], nibbles[:y], register)
            when 0xE
              ins_8xyE(nibbles[:x], nibbles[:y], register)
            end
          when 9
            ins_9xy0(nibbles[:x], nibbles[:y], register, pc)
          when 0xA
            ins_Annn(nibble[:nnn], register)
          when 0xB
            ins_Bnnn(nibbles[:nnn], register, pc)
          when 0xC
            ins_Cxnn(nibbles[:x], nibbles[:nn], register)
          when 0xD
            ins_Dxyn(nibbles[:x], nibbles[:y], nibbles[:n], register, memory, display)
          when 0xE
            case opcode & 0xFF
            when 0x9E
              ins_Ex9E(nibbles[:x], register, keyboard, pc)
            when 0xA1
              ins_ExA1(nibbles[:x], register, keyboard, pc)
            end
          when 0xF
            case opcode & 0xFF
            when 0x07
              ins_Fx07(vx, clock)
            when 0x0A
              ins_Fx0A(nibbles[:x], register, memory, pc, keyboard)
            when 0x15
              ins_Fx15(nibbles[:x], register, clock)
            when 0x18
              ins_Fx18(nibbles[:x], register, clock)
            when 0x1E
              ins_Fx1E(nibbles[:x], register)
            when 0x29
              ins_Fx29(nibbles[:x], register)
            when 0x33
              ins_Fx33(nibbles[:x], register, memory)
            when 0x55
              ins_Fx55(nibbles[:x], register, memory)
            when 0x65
              ins_Fx65(nibbles[:x], register, memory)
            end
          end
        end

        def ins_00E0(display)
          # "CLS"
          display.clear_screen
        end

        def ins_00EE(pc, stack)
          # "RET"
          pc.update_pointer(stack.pop)
        end

        def ins_1nnn(pc, nnn)
          # "JP addr"
          pc.update_pointer(nnn)
        end

        def ins_2nnn(nnn, stack, pc)
          # "CALL addr"
          stack.push(pc.index)
          pc.update_pointer(addr)
        end

        def ins_3xnn(vx, nn, register, pc)
          # "SE Vx, byte"          
          pc.increment if register.get_value(vx) == nn
        end

        def ins_4xnn(vx, nn, register, pc)
          # "SNE Vx, byte"
          pc.increment if register.get_value(vx) != nn
        end

        def ins_5xy0(vx, vy, register, pc)
          # "SE Vx, Vy"
          pc.increment if register.get_value(vx) == register.get_value(vy)
        end

        def ins_6xnn(vx, nn, register)
          # "LD Vx, byte"
          register.set_value(vx, nn)
        end

        def ins_7xnn(vx, nn, register)
          # "ADD Vx, byte"
          val = register.get_value(vx)
          val += nn
          register.set_value(vx, val)
        end

        def ins_8xy0(vx, vy, register)
          # "LD Vx, Vy"
          val = register.get_value(vy)
          register.set_value(vx, val)
        end

        def ins_8xy1(vx, vy, register)
          # "OR Vx, Vy"
          val = register.get_value(vx) | register.get_value(vy)
          register.set_value(vx, val)
        end

        def ins_8xy2(vx, vy, register)
          # "AND Vx, Vy"
          val = register.get_value(vx) & register.get_value(vy)
          register.set_value(vx, val)
        end

        def ins_8xy3(vx, vy, register)
          # "XOR Vx, Vy"
          val = register.get_value(vx) ^ register.get_value(vy)
          register.set_value(vx, val)
        end

        def ins_8xy4(vx, vy, register)
          # "ADD Vx, Vy"
          val = register.get_value(vx) + register.get_value(vy)
          carry = val > 255 ? 1 : 0
          register.set_value(vx, val)
          register.set_value(0xF, carry)
        end

        def ins_8xy5(vx, vy, register)
          # "SUB Vx, Vy"
          borrow = vx > vy ? 1 : 0
          val = register.get_value(vx) - register.get_value(vy)
          register.set_value(vx, val)
          register.set_value(0xF, borrow)
        end

        def ins_8xy6(vx, vy, register)
          # "SHR Vx {, Vy}"
          val = register.get_value(vx)
          lsb = val & 0x1 # 00000001
          register.set_value(0xF, lsb)
          register.set_value(vx, val >> 1)
        end

        def ins_8xy7(vx, vy, register)
          # "SUBN Vx, Vy"
          borrow = vy > vx ? 1 : 0
          val = register.get_value(vy) - register.get_value(vx)
          register.set_value(vx, val)
          register.set_value(0xF, borrow)
        end

        def ins_8xyE(vx, vy, register)
          # "SHL Vx {, Vy}"
          val = register.get_value(vx)
          msb = val & 0x80 # 10000000
          register.set_value(0xF, msb)
          register.set_value(vx, val << 1)
        end

        def ins_9xy0(vx, vy, register, pc)
          # "SNE Vx, Vy"
          pc.increment if register.get_value(vx) != register.get_value(vy)
        end

        def ins_Annn(nnn, register)
          # "LD I, addr"
          register.set_index(nnn)
        end

        def ins_Bnnn(nnn, register, pc)
          # "JP V0, addr"
          new_addr = register[0] + nnn
          pc.update_pointer(new_addr)
        end

        def ins_Cxnn(vx, nn, register)
          # "RND Vx, byte"
          val = rand(0..255) & nn
          register.set_value(vx, val)
        end

        def ins_Dxyn(vx, vy, n, register, memory, display)
          # "DRW Vx, Vy, nibble"
          # Display n-byte sprite starting at memory location I at (Vx, Vy), set VF = collision.
          # The interpreter reads n bytes from memory, starting at the address stored in I. 
          # These bytes are then displayed as sprites on screen at coordinates (Vx, Vy). 
          # Sprites are XORed onto the existing screen. If this causes any pixels to be erased, 
          # VF is set to 1, otherwise it is set to 0. If the sprite is positioned so part of it 
          # is outside the coordinates of the display, it wraps around to the opposite side of 
          # the screen.
          (0..(n - 1)).each do |row|
            y = register.data[vy] % Display::HEIGHT + row # % helps with wraping sprites
            sprite = memory.get_data_at(register.index + row)
            break if y.nil? || y > Display::HEIGHT - 1

            # Draw the sprite to the display buffer
            (0..7).each do |position|
              x = register.data[vx] % Display::WIDTH + position
              break if x.nil? || x > Display::WIDTH - 1

              pixel_to_draw = sprite.to_s(2)[position]
              current_pixel = display_buffer[x, y]
              display.display_buffer[x, y] = pixel_to_draw ^ current_pixel

              # Set VF based on pixel collision
              register.data[0xF] = 1 if pixel_to_draw == current_pixel ? 1 : 0
            end
          end


        end

        def ins_Ex9E(vx, register, keyboard, pc)  
          # "SKP Vx"
          pc.increment if keyboard.key_pressed?(register.get_value(vx))
        end

        def ins_ExA1(vx, register, keyboard, pc)
          # "SKNP Vx"
          pc.increment unless keyboard.key_pressed?(register.get_value(vx))
        end

        def ins_Fx07(vx, clock)
          # "LD Vx, DT"
          register.set_value(vx, clock.delay_timer)
        end

        def ins_Fx0A(vx, register, memory, pc, keyboard)
          # "LD Vx, K"
          if keyboard.key_pressed?
            register.set_value(vx, keyboard.get_pressed_key)
          else
            pc.decrement
          end
        end

        def ins_Fx15(vx, register, clock)
          # "LD DT, Vx"
          clock.set_delay_timer(register.get_value(vx))
        end

        def ins_Fx18(vx, register, clock)
          # "LD ST, Vx"
          clock.set_sound_timer(register.get_value(vx))
        end

        def ins_Fx1E(vx, register)
          # "ADD I, Vx"
          val = register.index + register.get_value(vx)
          register.set_index(val)
        end

        def ins_Fx29(vx, register)
          # "LD F, Vx"
          first_byte = register.get_value(vx) * 5 # Fonts are 5 bytes high
          register.set_value(vx, first_byte + Font::FONT_OFFSET)
        end

        def ins_Fx33(vx, register, memory)
          # "LD B, Vx"
          target = register.get_value(vx)
          memory.add_to_memory(register.index, target / 100) # Hundreds
          memory.add_to_memory(register.index + 1, (target % 100) / 10) # Tens
          memory.add_to_memory(register.index + 2, target % 10) # Ones
        end

        def ins_Fx55(vx, register, memory)
          # "LD [I], Vx".
          (0..vx).each do |position|
            memory.add_to_memory(register.index + position, register.get_value(position))
          end
        end

        def ins_Fx65(vx, register, memory)
          # "LD Vx, [I]"
          (0..vx).each do |position|
            value = memory.get_data_at(register.index + position)
            register.set_value(position, value)
          end
        end
      end
    end
  end
end
