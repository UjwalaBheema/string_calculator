require_relative '../lib/string_calculator'
require 'benchmark'
RSpec.describe StringCalculator do
    it "has a version number" do
      expect(StringCalculator::VERSION).not_to be nil
    end
  
    describe ".add" do
      context "basic functionality" do
        it "returns 0 for an empty string" do
          expect(StringCalculator.add("")).to eq(0)
        end
        
        it "returns the number for a single number" do
          expect(StringCalculator.add("1")).to eq(1)
        end
        
        it "returns the sum for two comma-separated numbers" do
          expect(StringCalculator.add("1,5")).to eq(6)
        end
        
        it "handles any amount of numbers" do
          expect(StringCalculator.add("1,2,3,4,5")).to eq(15)
        end
        
        it "handles new lines between numbers as delimiters" do
          expect(StringCalculator.add("1\n2,3")).to eq(6)
        end
        
        it "supports custom delimiters" do
          expect(StringCalculator.add("//;\n1;2")).to eq(3)
        end
      end
      
      context "negative number handling" do
        it "throws an exception for negative numbers" do
          expect { StringCalculator.add("1,-2") }.to raise_error(
            RuntimeError, "negative numbers not allowed -2"
          )
        end
        
        it "includes all negative numbers in the exception message" do
          expect { StringCalculator.add("1,-2,-3,-4") }.to raise_error(
            RuntimeError, "negative numbers not allowed -2,-3,-4"
          )
        end
      end
      
      context "edge cases" do
        it "handles multi-digit numbers correctly" do
          expect(StringCalculator.add("10,20,30")).to eq(60)
        end
        
        it "ignores whitespace around numbers" do
          expect(StringCalculator.add("1, 2, 3")).to eq(6)
        end
        
        it "handles special characters as delimiters" do
          expect(StringCalculator.add("//.\n1.2.3")).to eq(6)
        end
        
        it "handles zeros correctly" do
          expect(StringCalculator.add("0,0,0")).to eq(0)
        end
        
        it "treats non-numeric inputs as zero" do
          expect(StringCalculator.add("1,a,3")).to eq(4)
        end
        
        it "treats empty parts between delimiters as zero" do
          expect(StringCalculator.add("1,,3")).to eq(4)
        end
      end
      
      context "advanced delimiter handling" do
        it "supports multi-character delimiters" do
          expect(StringCalculator.add("//[***]\n1***2***3")).to eq(6)
        end
        
        it "supports multiple different delimiters" do
          expect(StringCalculator.add("//[*][%]\n1*2%3")).to eq(6)
        end
        
        it "supports delimiters with special regex characters" do
          expect(StringCalculator.add("//+\n1+2+3")).to eq(6)
        end
      end

      context "with large inputs" do
        it "handles a long list of numbers efficiently" do
          # Create a string with 10,000 numbers (1,2,3,1,2,3...)
          numbers = (1..10_000).map { |i| i % 10 }.join(',')
          
          # Set a time threshold (adjust as needed)
          time_threshold = 0.5 # seconds
          
          # Measure execution time
          execution_time = Benchmark.realtime do
            StringCalculator.add(numbers)
          end
          
          # Verify the result is correct (sum of 0-9 repeated)
          expect(StringCalculator.add(numbers)).to eq(45_000) # (0+1+2+...+9) * 1000
          
          # Verify it executes within the time threshold
          expect(execution_time).to be < time_threshold
        end
        
        it "processes a large input with custom delimiters efficiently" do
          # Create a string with 1,000 numbers separated by a custom delimiter
          numbers = "//;\n" + (1..1_000).map { |i| i % 10 }.join(';')
          
          time_threshold = 0.2 # seconds
          
          execution_time = Benchmark.realtime do
            StringCalculator.add(numbers)
          end
          
          expect(StringCalculator.add(numbers)).to eq(4_500) # (0+1+2+...+9) * 100
          expect(execution_time).to be < time_threshold
        end
        
        it "handles multiple complex delimiters with large input efficiently" do
          # Create a string with multi-character delimiters
          numbers = "//[***][%%%]\n" + (1..500).map { |i| i % 10 }.join('***')
          # Add additional numbers with second delimiter
          numbers += "%%%" + (1..500).map { |i| i % 10 }.join('%%%')
          
          time_threshold = 0.3 # seconds
          
          execution_time = Benchmark.realtime do
            StringCalculator.add(numbers)
          end
          
          expect(StringCalculator.add(numbers)).to eq(4_500) # (0+1+2+...+9) * 100
          expect(execution_time).to be < time_threshold
        end
        
        it "performs well with pathological input patterns" do
          # Create a string with nested delimiters and edge cases
          # This includes empty segments, whitespace, and non-numeric characters
          numbers = "//[!@#]\n" + (1..300).map do |i|
            i % 3 == 0 ? "!@#" : # Empty segment every 3rd position
            i % 5 == 0 ? "#{i % 10} !@#" : # Whitespace before delimiter
            i % 7 == 0 ? "#{i % 10}x!@#" : # Non-numeric character
            "#{i % 10}!@#"
          end.join
          
          time_threshold = 0.3 # seconds
          
          execution_time = Benchmark.realtime do
            result = StringCalculator.add(numbers)
            # We don't assert the exact result here since it depends on
            # how the implementation handles the edge cases
          end
          
          expect(execution_time).to be < time_threshold
        end
      end
      
      context "with memory usage considerations" do
        it "doesn't consume excessive memory with very large inputs" do
          # Skip this test in CI environments where memory might be constrained
          skip "Memory test disabled in CI environment" if ENV['CI']
          
          # Create a very large input string (~5MB)
          numbers = (1..500_000).map { |i| i % 10 }.join(',')
          
          # Ruby doesn't have a built-in way to measure memory usage directly
          # But we can use ObjectSpace to get a rough idea
          require 'objspace'
          
          GC.start # Force garbage collection before the test
          memory_before = ObjectSpace.memsize_of_all
          
          result = StringCalculator.add(numbers)
          
          GC.start # Force garbage collection after the test
          memory_after = ObjectSpace.memsize_of_all
          
          memory_used = memory_after - memory_before
          
          # The memory check is a bit fuzzy, so set a generous threshold
          # This is mainly to catch significant regressions
          expect(memory_used).to be < 20_000_000 # 20MB (adjust as needed)
          
          # Also verify the calculation is correct
          expect(result).to eq(2_250_000) # (0+1+2+...+9) * 50000
        end
      end
  
    end
  end



# RSpec.describe StringCalculator, "performance" do
#   describe ".add" do

#   end
# end