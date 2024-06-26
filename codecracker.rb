# frozen_string_literal: true

require './constants'

# Class representing a Codecracker.
#
# This class provides methods to:
#  - Take a guess input from an user
#  - Check feedback from previous guess and generate new guess accordingly
class Codecracker
  include Constants
  attr_reader :guess, :present_colors

  def initialize
    @guess = ''
    @pegs_for_computer = {
      red: 0,
      white: 0
    }
    @colors_for_computer = %w[red blue green yellow cyan purple]
    @used_colors = []
    @present_colors = []
    @pegs_registered = 0
    @used_answers = []
    @possible_codes = []
  end

  # The following function takes guess from an user
  def guess_code
    puts 'Available colors are: red, green, blue, yellow, cyan and purple.'
    puts 'Enter your guess (without quotation marks) in the following format "color color color color": '
    loop do
      @guess = gets.chomp
      break if /^(#{PATTERN}\s){3}#{PATTERN}$/.match(@guess)

      puts 'Wrong input. Please try again:'
    end
    @guess
  end

  # The following method generates first guess, it is used only once
  def generate_first_guess
    color = @colors_for_computer.shuffle.sample.to_s
    @used_colors.push(color)
    @colors_for_computer.delete(color)
    @guess = "#{color} #{color} #{color} #{color}"
  end

  # The following method checks feedback from the previous guess
  def count_key_pegs(board, row)
    board[row + 1][4].each do |element|
      if element.match(/\A#{Regexp.escape(COLORS[:red])}/)
        @pegs_for_computer[:red] += 1
      elsif element.match(/\A\e\[0m/)
        @pegs_for_computer[:white] += 1
      end
    end
  end

  # If there are more key pegs in comparison to previous guess,
  # the following method will add a color that resulted in more key pegs
  def append_correct_colors
    ((@pegs_for_computer[:red] + @pegs_for_computer[:white]) - @pegs_registered).times do
      @present_colors.push(@used_colors[@used_colors.length - 1])
    end

    return unless @pegs_for_computer[:red] + @pegs_for_computer[:white] > @pegs_registered

    @pegs_registered = @pegs_for_computer[:red] + @pegs_for_computer[:white]
  end

  # When all correct colors are collected
  # the following method will generate guesses until the right one is found
  # it will be run only if all correct colors are collected
  def shuffle_guess
    @used_answers.push(@guess) if @used_answers.empty?

    generate_possible_codes if @pegs_for_computer[:red] == 2 && @possible_codes.empty?

    loop do
      @guess = @possible_codes.empty? ? @present_colors.shuffle.join(' ') : @possible_codes.shift.join(' ')
      break unless @used_answers.include?(@guess)
    end

    @pegs_for_computer[:red] = 0
    @pegs_for_computer[:white] = 0
    @used_answers.push(@guess)
    @guess
  end

  # This method will generate a guess when 4 correct colors have not been collected yet
  def generate_guess
    @guess = ''

    @present_colors.each do |element|
      @guess += "#{element} "
    end

    add_new_color_to_guess

    @pegs_for_computer[:red] = 0
    @pegs_for_computer[:white] = 0

    @guess = @guess.rstrip
  end

  private

  # The following method will generate all possible codes
  def generate_possible_codes
    (0..2).each do |i|
      (i + 1..3).each do |j|
        splitted_guess = @guess.split(' ')

        aux = splitted_guess[i]
        splitted_guess[i] = splitted_guess[j]
        splitted_guess[j] = aux

        @possible_codes.push(splitted_guess)
      end
    end
  end

  # The following method adds a new color when generating a guess
  def add_new_color_to_guess
    color = @colors_for_computer.shuffle.sample.to_s
    how_many_times_new_color = 4 - @pegs_registered

    how_many_times_new_color.times do
      @guess += "#{color} "
    end

    @used_colors.push(color)
    @colors_for_computer.delete(color)
  end
end
