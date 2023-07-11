# convert.rb

require 'thor'
require 'csv'
require 'json'
require 'tty-prompt'

def check_output_ext(output_path, target_ext)
  output_ext = output_path.split('.')[-1]
  if output_ext != target_ext
    output_path = output_path.sub(/\.[^.]+\z/, ".#{target_ext}")
    puts "Your target extension doesn't match the target file name. The new output path is #{output_path}"
  end
  return output_path
end

def convert_csv_to_json(input_path, output_path)
  json_array = []

  CSV.foreach(input_path, headers: true) do |row|
    json_object = {}

    row.each do |header, field|
      json_object[header] = field
    end

    json_array << json_object
  end

  output_path = check_output_ext(output_path, 'json')

  File.write(output_path, JSON.pretty_generate(json_array))
end

def convert_json_to_csv(input_path, output_path)
  json_content = File.read(input_path)
  json_array = JSON.parse(json_content)
  headers = json_array.first.keys

  output_path = check_output_ext(output_path, 'csv')


  CSV.open(output_path, 'w') do |csv|
    # Écrire les en-têtes dans le fichier CSV
    csv << headers

    # Parcourir chaque objet dans le tableau JSON
    json_array.each do |json_object|
      # Écrire une ligne dans le fichier CSV pour chaque objet
      csv << json_object.values
    end
  end
end

class ConverterCLI < Thor

  desc "convert", "convert a file from user provided INPUT path to a new TYPE and save at user provided OUTPUT path"
  def convert
    prompt = TTY::Prompt.new

    input = prompt.ask("Quel est le chemin du fichier à convertir?")
    input_ext = input.split('.')[-1]

    file_types = ["json", "csv"]
    file_types.delete(input_ext)

    type = prompt.select("Quel est le type de fichier de sortie souhaité?", file_types)
    output = prompt.ask("Où souhaitez-vous sauvegarder le nouveau fichier?")

    if type === 'json'
      convert_csv_to_json(input, output)
    elsif type === 'csv'
      convert_json_to_csv(input, output)
    end
    puts "Converting file at #{input} to type #{type}, will save result at #{output}"
  end
end