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
    index = -1
    codes.map do |line|
      index += 1
      transfer_symboled_a_instruction(line, index)
    end
  end

  def store_label_symbols(codes)
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

#   def transfer_pseudo_commands(codes)
#     index = -1
#     codes.map do |line|
#       index += 1
#       transfer_pseudo_command(line, index)
#     end
#   end

  def process(codes)
    codes = clean_comments_and_white_spaces(codes)
    codes = store_label_symbols(codes)
    # codes = transfer_pseudo_commands(codes)
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
end

assembler = HackAssembler.new
result = assembler.process(HackAssembler.get_file(ARGV[0]))

puts result
ARGV.clear

binding.pry
