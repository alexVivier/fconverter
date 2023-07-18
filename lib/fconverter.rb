# convert.rb

require 'thor'
require 'csv'
require 'json'
require 'tty-prompt'

require_relative 'converter/converter'
require_relative 'converter/csv_converter'
require_relative 'converter/json_converter'

class ConverterCLI < Thor
  desc "convert", "convert a file from user provided INPUT path to a new TYPE and save at user provided OUTPUT path"
  def convert
    prompt = TTY::Prompt.new

    useS3 = prompt.yes?("Do you want to convert file from S3 ?")

    input = prompt.ask("What is the path of the file to convert?")
    input_ext = input.split('.')[-1]

    file_types = ["json", "csv"]
    file_types.delete(input_ext)

    type = prompt.select("What is the desired output file type?", file_types)
    output = prompt.ask("Where do you want to save the new file?")

    if type === 'json'
      converter = CSVConverter.new(input, output)
    elsif type === 'csv'
      converter = JSONConverter.new(input, output)
    end

    if useS3
      converter.convertFromS3
    else
      converter.convert
    end

    puts "Converting file at #{input} to type #{type}, will save result at #{output}"
  end
end