class JSONConverter < Converter
    def convert
      check_output_ext('csv')
  
      json_content = File.read(@input_path)
      json_array = JSON.parse(json_content)
      headers = json_array.first.keys
  
      CSV.open(@output_path, 'w') do |csv|
        csv << headers
  
        json_array.each do |json_object|
          csv << json_object.values
        end
      end
    end


    def convertFromS3

      download_file(@input_path, 'csv')
      json_array = []
  
      CSV.foreach("./tmpInput.#{ext}", headers: true) do |row|
        json_object = {}
  
        row.each do |header, field|
          json_object[header] = field
        end
  
        json_array << json_object
      end
  
      File.write("./tmpOutput.#{ext}", JSON.pretty_generate(json_array))
      upload_file_with_presigned_url(@output_path, 'json')
    end
  end