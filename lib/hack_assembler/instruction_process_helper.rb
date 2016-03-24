class HackAssembler
  module InstructionProcessHelper
    COMMENT = /\/\/.*/
    A_INSTRUCTION = /^@\d*/
    C_INSTRUCTION = /[\+\-\=\;]+/

    def remove_comments(line)
      line.gsub(COMMENT, '').strip
    end

    def transfer_a_intruction(line)
      match = line.match(A_INSTRUCTION)

      if match
        a_instruction = match[0]
        a_instruction.sub!("@", "")
        a_instuction_to_bin(a_instruction)
      else
        line
      end
    end

    def transfer_c_instruction(line)
      if line.match(C_INSTRUCTION)
        dest_and_comp = line.split("=")
        if dest_and_comp.length == 1
          dest = "null"
        else
          dest = dest_and_comp[0]
        end
        comp = dest_and_comp.last.split(";")[0]
        jump = dest_and_comp.last.split(";")[1] || "null"

        dest_bin = InstructionTable::DESTINATIONS[dest]
        comp_bin = InstructionTable::COMPS[comp]
        jump_bin = InstructionTable::JUMPS[jump]

        "111#{comp_bin}#{dest_bin}#{jump_bin}"
      else
        line
      end
    end

    private

    def a_instuction_to_bin(instruction)
      instruction.to_i.to_s(2).rjust(16, "0")
    end
  end
end
