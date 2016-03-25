require "hack_assembler/version"
require "hack_assembler/symbol_table"
require "hack_assembler/instruction_table"
require "hack_assembler/instruction_process_helper"
require "pry"

class HackAssembler
  include InstructionProcessHelper

  def clean_comments_and_white_spaces(file)
    file.map do |line|
      code = remove_comments(line)
      code unless code.empty?
    end.compact
  end

  def transfer_a_instructions(codes)
    codes.map do |line|
      transfer_a_intruction(line)
    end
  end

  def transfer_c_instructions(codes)
    codes.map do |line|
      transfer_c_instruction(line)
    end
  end

  def transfer_symboled_a_instructions(codes)
    codes.map do |line|
      transfer_symboled_a_instruction(line)
    end
  end

  def store_and_remove_label_symbols(codes)
    index = -1
    codes.map do |line|
      index += 1
      if store_label_symbol?(line, index)
        # cause label symbol can't count as a instruction
        index -= 1
        nil
      else
        line
      end
    end.compact
  end

  def store_variable_symbols(codes)
    variables = codes.select do |line|
      variable_symbol?(line)
    end.uniq
    count = 16
    variables.each do |variable|
      var_name = variable.sub("@", "")
      # while symbol_table.table.values.include?(count.to_s) do
      #   count += 1
      # end

      symbol_table.push(var_name => count.to_s)
      count +=1
    end
  end

  def process(codes)
    codes = clean_comments_and_white_spaces(codes)
    codes = store_and_remove_label_symbols(codes)
    store_variable_symbols(codes)
    codes = transfer_a_instructions(codes)
    codes = transfer_symboled_a_instructions(codes)
    codes = transfer_a_instructions(codes)
    codes = transfer_c_instructions(codes)
    codes.join("\n")
  end

  def symbol_table
    @symbol_table ||= SymbolTable.new
  end

  def self.get_file(file_name)
    lib_path = "#{File.expand_path(File.dirname(__FILE__))}/../../"
    file_path = "#{lib_path}#{file_name}"
    File.open(file_path) do |f|
      f.read
    end.split("\n")
  end

  def self.write_file(file_name)
    lib_path = "#{File.expand_path(File.dirname(__FILE__))}/../../"
    result = self.new.process(get_file(file_name))
    store_name = file_name.split("/").last.split(".")[0]
    file = File.new("#{lib_path}#{store_name}.hack", "w")
    file.write(result)
  end
end

file_names = [
  "add/Add.asm",
  "max/Max.asm",
  "pong/Pong.asm",
  "rect/Rect.asm"
]
file_names.each do |file_name|
  HackAssembler.write_file(file_name)
end


