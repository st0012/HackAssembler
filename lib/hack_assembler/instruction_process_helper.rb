class HackAssembler
  module InstructionProcessHelper
    COMMENT = /\/\/.*/
    A_INSTRUCTION = /^@\d*/

    def remove_comments(line)
      line.gsub(COMMENT, '').strip
    end

    def transfer_a_intruction(line)
      match = l.match(A_INSTRUCTION)

      if match
        a_instruction = match[0]
        a_instruction.sub!("@", "")
        a_instuction_to_bin(a_instruction)
      else
        l
      end
    end

    def a_instuction_to_bin(instruction)
      instruction.to_i.to_s(2).rjust(16, "0")
    end
  end
end
