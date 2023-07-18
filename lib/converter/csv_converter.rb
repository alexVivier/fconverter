
class CSVConverter < Converter
    def convert
      check_output_ext('json')
  
      json_array = []
  
      CSV.foreach(@input_path, headers: true) do |row|
        json_object = {}
  
        row.each do |header, field|
          json_object[header] = field
        end
  
        json_array << json_object
      end
  
      File.write(@output_path, JSON.pretty_generate(json_array))
    end


    def convertFromS3

      download_file(@input_path, 'json')
      json_array = []
  
      CSV.foreach("./tmpInput.#{ext}", headers: true) do |row|
        json_object = {}
  
        row.each do |header, field|
          json_object[header] = field
        end
  
        json_array << json_object
      end
  
      File.write("./tmpOutput.#{ext}", JSON.pretty_generate(json_array))
      upload_file_with_presigned_url(@output_path, 'csv')
    end
  end