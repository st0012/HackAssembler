require "hack_assembler/version"
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

  def process(file)
    codes = clean_comments_and_white_spaces(file)
    codes = transfer_a_instructions(codes)
    codes = transfer_c_instructions(codes)
  end

  def self.get_file(file_name)
    lib_path = "#{File.expand_path(File.dirname(__FILE__))}/../../"
    file_path = "#{lib_path}#{file_name}"
    File.open(file_path)
  end
end

assembler = HackAssembler.new
result = assembler.process(HackAssembler.get_file(ARGV[0]))

binding.pry
