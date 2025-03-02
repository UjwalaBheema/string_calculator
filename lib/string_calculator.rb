# lib/string_calculator.rb
require_relative "string_calculator/version"

module StringCalculator
  class Error < StandardError; end
  
  def self.add(numbers)
    return 0 if numbers.empty?
    
    delimiter = ","
    numbers_to_parse = numbers
    
    if numbers.start_with?("//")
      delimiter_section = numbers.split("\n")[0][2..-1]
      numbers_to_parse = numbers.split("\n", 2)[1]
      
      if delimiter_section.start_with?("[")
        # Handle multi-character or multiple delimiters
        delimiters = []
        delimiter_section.scan(/\[(.*?)\]/) { |match| delimiters << Regexp.escape(match[0]) }
        
        # Replace all delimiters with a common one
        delimiters.each do |del|
          numbers_to_parse = numbers_to_parse.gsub(Regexp.new(del), delimiter)
        end
      else
        # Simple single-character delimiter (escape for regex special chars)
        delimiter_char = Regexp.escape(delimiter_section)
        numbers_to_parse = numbers_to_parse.gsub(Regexp.new(delimiter_char), delimiter)
      end
    end
    
    # Always handle newlines as delimiters
    numbers_to_parse = numbers_to_parse.gsub("\n", delimiter)
    
    # Parse the numbers
    parsed_numbers = numbers_to_parse.split(delimiter).map do |n|
      n.strip.empty? ? 0 : n.strip.to_i
    end
    
    # Check for negative numbers
    negative_numbers = parsed_numbers.select { |n| n < 0 }
    if negative_numbers.any?
      raise "negative numbers not allowed #{negative_numbers.join(',')}"
    end
    
    # Return the sum
    parsed_numbers.sum
  end
end