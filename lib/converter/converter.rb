require 'open-uri'
require 'net/http'


class Converter
    def initialize(input_path, output_path)
      @input_path = input_path
      @output_path = output_path
    end
  
    protected
  
    def check_output_ext(target_ext)
      output_ext = @output_path.split('.')[-1]
      if output_ext != target_ext
        @output_path = @output_path.sub(/\.[^.]+\z/, ".#{target_ext}")
        puts "Your target extension doesn't match the target file name. The new output path is #{@output_path}"
      end
    end

    def download_file(uri, ext)
      open(uri) do |u|
        File.open("./tmpInput.#{ext}", 'wb') { |f| f.write(u.read) }
      end
    end

    def upload_file_with_presigned_url(presigned_url, ext)
      uri = URI.parse(presigned_url)
    
      File.open("./tmpOutput.#{ext}") do |file|
        request = Net::HTTP::Put.new(uri)
        request.body = file.read
    
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.request(request)
      end
      File.delete("./tmpInput.#{ext}")
      File.delete("./tmpOutput.#{ext}")
    end
  end