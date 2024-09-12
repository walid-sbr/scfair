module Basic
  
  class << self

    def link_alive_quick?(url)
      uri = URI.parse(url)
      request = Net::HTTP::Get.new(uri)
      response = nil
      
      begin
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(request) do |res|
            # Read a small part of the body to ensure data is returned
            res.read_body do |chunk|
              if chunk
                return true
              end
            end
          end
        end
      rescue => e
        puts "Error: #{e.message}"
        return false
      end
      
      false
    end
    
    def link_alive?(url)
      uri = URI.parse(url)
      request = Net::HTTP::Head.new(uri)
      response = nil
      
      begin
        response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
          http.request(request)
        end
      rescue => e
        puts "Error: #{e.message}"
        return false
      end
      
      case response.code.to_i
      when 200
        true
      else
        false
      end
    end
    
    def format_number_with_apostrophes(number)
      # Convert the number to a string and reverse it
      str = number.to_s.reverse
      # Insert apostrophes every three digits
      formatted_str = str.gsub(/(\d{3})(?=\d)/, '\\1\'')
      # Reverse the string back to its original order
      formatted_str.reverse
    end
    

    def safe_parse_json json, default
      h = default
      begin
        h = JSON.parse json
      rescue
      end
      return h
    end
  end
end
