module Basic
  
  class << self

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
