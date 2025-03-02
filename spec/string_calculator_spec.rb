require_relative '../lib/string_calculator'

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
    end
  end