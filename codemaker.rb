# frozen_string_literal: true

require './constants'

# Class representing a Codemaker.
#
# This class provides methods to:
#  - Generate a secret code
#  - Check a guess from Codecracker to count key pegs which will be inserted into the board
class Codemaker
  include Constants

  attr_reader :code

  def initialize
    @code = []
  end

  # Iterate through guess, count red and white pegs to insert them into the board later
  def check_guess(guess)
    key_pegs = { red: 0, white: 0 }
    code_copy = @code.dup

    guess.each_with_index do |element, index|
      if code_copy[index] == element
        key_pegs[:red] += 1
        code_copy[index] = nil
        guess[index] = ''
      end
    end

    guess.each do |element|
      if code_copy.include?(element)
        key_pegs[:white] += 1
        code_copy[code_copy.index(element)] = nil
      end
    end
    key_pegs
  end
end

# Subclass representing a Computer Codemaker.
#
# This subclassprovides method to:
#  - Generate a secret code
class ComputerCodemaker < Codemaker
  # Generate a secret code which Player Codecracker will try to unriddle
  def set_code
    4.times do
      @code.push(COLORS.keys.shuffle.sample.to_s)
    end
  end
end

# Subclass representing a Player Codemaker.
#
# This subclass provides method to:
#  - Let user enter a secret code
class PlayerCodemaker < Codemaker
  # Type in secret code which Computer Codecracker will try to unriddle
  def set_code
    puts 'Available colors are: red, green, blue, yellow, cyan and purple.'
    puts 'Type in the secret code (without quotation marks) in the following format "color color color color": '
    loop do
      @code = gets.chomp
      break if /^(#{PATTERN}\s){3}#{PATTERN}$/.match(@code)

      puts 'Wrong input. Please try again:'
    end
    @code = @code.split(' ')
    @code
  end
end
