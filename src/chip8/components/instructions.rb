# frozen_string_literal: true

module Chip8
  module Components
    class Instructions
      class << self
        def execute(nibbles, display, keyboard, memory, pc, register, stack, clock)
          case nibbles[:instruction] 
          when 0
            case opcode & 0x0FFF
            when 0x0E0
              "CLS"
            when 0x0EE
              "RET"
            end
          when 1
            # "JP #{nnn}"
            pc.update_pointer(addr)
          when 2
            "CALL #{nnn}"
          when 3
            "SE #{x}, #{nn}"
          when 4
            "SNE #{x}, #{nn}"
          when 5
            "SE #{x}, #{y}"
          when 6
            "LD #{x}, #{nn}"
          when 7
            "ADD #{x}, #{nn}"
          when 8
            case opcode & 0x0F
            when 0
              "LD #{x}, #{y}"
            when 1
              "OR #{x}, #{y}"
            when 2
              "AND #{x}, #{y}"
            when 3
              "XOR #{x}, #{y}"
            when 4
              "ADD #{x}, #{y}"
            when 5
              "SUB #{x}, #{y}"
            when 6
              "SHR #{x} {, #{y}}"
            when 7
              "SUBN #{x}, #{y}"
            when 0xE
              "SHL #{x} {, #{y}}"
            end
          when 9
            "SNE #{x}, #{y}"
          when 0xA
            "LD #{index_register}, #{nnn}"
          when 0xB
            "JP V0, #{nnn}"
          when 0xC
            "RND #{x}, #{nn}"
          when 0xD
            "DRW #{x}, #{y}, #{n}"
          when 0xE
            case opcode & 0xFF
            when 0x9E
              "SKP #{x}"
            when 0xA1
              "SKNP #{x}"
            end
          when 0xF
            case opcode & 0xFF
            when 0x07
              "SKNP #{x}"
            when 0x0A
              "LD #{x}, K"
            when 0x15
              "LD DT, #{x}"
            when 0x18
              "LD ST, #{x}"
            when 0x1E
              "ADD #{index_register}, #{x}"
            when 0x29
              "LD F, #{x}"
            when 0x33
              "LD B, #{x}"
            when 0x55
              "LD [#{index_register}], #{x}"
            when 0x65
              "LD #{x}, [#{index_register}]"
            end
          end
        end

        def ins_00E0
          "CLS"
        end

        def ins_00EE
          "RET"
        end

        def ins_1nnn(pc, addr)
          # "JP addr"
          pc.update_pointer(addr)
        end

        def ins_2nnn(addr)
          "CALL addr"
        end

        def ins_3xnn(vx, byte)
          "SE Vx, byte"
        end

        def ins_4xkk(vx, byte)
          "SNE Vx, byte"
        end

        def ins_5xy0(vx, vy)
          "SE Vx, Vy"
        end

        def ins_6xkk(vx, byte)
          "LD Vx, byte"
        end

        def ins_7xkk(vx, byte)
          "ADD Vx, byte"
        end

        def ins_8xy0(vx, vy)
          "LD Vx, Vy"
        end

        def ins_8xy1(vx, vy)
          "OR Vx, Vy"
        end

        def ins_8xy2(vx, vy)
          "AND Vx, Vy"
        end

        def ins_8xy3(vx, vy)
          "XOR Vx, Vy"
        end

        def ins_8xy4(vx, vy)
          "ADD Vx, Vy"
        end

        def ins_8xy5(vx, vy)
          "SUB Vx, Vy"
        end

        def ins_8xy6(vx, vy)
          "SHR Vx {, Vy}"
        end

        def ins_8xy7(vx, vy)
          "SUBN Vx, Vy"
        end

        def ins_8xyE(vx, vy)
          "SHL Vx {, Vy}"
        end

        def ins_9xy0(vx, vy)
          "SNE Vx, Vy"
        end

        def ins_Annn(addr)
          "LD I, addr"
        end

        def ins_Bnnn(addr)
          "JP V0, addr"
        end

        def ins_Cxnn(vx, byte)
          "RND Vx, byte"
        end

        def ins_Dxyn(vx, vy, nibble)
          "DRW Vx, Vy, nibble"
        end

        def ins_Ex9E(vx)
          "SKP Vx"
        end

        def ins_ExA1(vx)
          "SKNP Vx"
        end

        def ins_Fx07(vx, dt)
          "LD Vx, DT"
        end

        def ins_Fx0A(vx)
          "LD Vx, K"
        end

        def ins_Fx15(vx, dt)
          "LD DT, Vx"
        end

        def ins_(vx)
          "LD ST, Vx"
        end

        def ins_Fx1E(vx)
          "ADD I, Vx"
        end

        def ins_Fx29(vx)
          "LD F, Vx"
        end

        def ins_Fx33(vx)
          "LD B, Vx"
        end

        def ins_Fx55(vx)
          "LD [I], Vx"
        end

        def ins_Fx65(vx)
          "LD Vx, [I]"
        end
      end
    end
  end
end
