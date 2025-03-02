# String Calculator

A simple string calculator gem built as a TDD Kata exercise.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'string_calculator'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install string_calculator
```

## Usage

The `StringCalculator` gem provides a simple way to calculate the sum of numbers in a string:

```ruby
require 'string_calculator'

# Basic usage
StringCalculator.add("1,2,3") # => 6

# Using newlines as delimiters
StringCalculator.add("1\n2,3") # => 6

# Using custom delimiters
StringCalculator.add("//;\n1;2") # => 3

# Using multi-character delimiters
StringCalculator.add("//[***]\n1***2***3") # => 6

# Using multiple delimiters
StringCalculator.add("//[*][%]\n1*2%3") # => 6
```

The calculator will throw an exception when negative numbers are provided:

```ruby
StringCalculator.add("1,-2") # => raises "negative numbers not allowed -2"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/username/string_calculator](https://github.com/username/string_calculator).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).