class HackAssembler
  module InstructionProcessHelper
    COMMENT = /\/\/.*/
    A_INSTRUCTION = /^@\d+/
    C_INSTRUCTION = /[\+\-\=\;]+/
    SYMBOLED_A_INSTRUCTION = /^@[\w+.]+/
    LABEL_SYMBOL = /\(.*\)/
    VARIABLE_SYMBOL = /^@[a-zA-Z]+/

    def remove_comments(line)
      line.gsub(COMMENT, '').strip
    end

    def transfer_a_intruction(line)
      match = line.match(A_INSTRUCTION)

      if match
        a_instruction = match[0]
        a_instruction = a_instruction.sub("@", "")
        a_instruction_to_bin(a_instruction)
      else
        line
      end
    end

    def store_label_symbol?(line, index)
      if match = line.match(LABEL_SYMBOL)
        symbol = match[0].gsub(/\(|\)/, "")
        symbol_table.push(symbol => index.to_s)
        true
      else
        false
      end
    end

    def variable_symbol?(line)
      var_name = line.sub("@", "")
      line.match(VARIABLE_SYMBOL) && !symbol_table.table.keys.include?(var_name)
    end

    def transfer_symboled_a_instruction(line, index)
      if match = line.match(SYMBOLED_A_INSTRUCTION)
        symbol = match[0].sub("@", "")
        decimal_value = symbol_table[symbol]
        "@#{decimal_value}"
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

    def a_instruction_to_bin(instruction)
      instruction.to_i.to_s(2).rjust(16, "0")
    end
  end
end
