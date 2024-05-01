# frozen_string_literal: true

# Class representing a Mastermind board.
#
# This class provides methods to:
#  - Print board into the terminal
#  - Insert a guess into the board
#  - Insert key pegs into the board
#  - Check red key pegs, i.e. if the code is cracked
#  - Set players role
class Board
  COLORS = {
    red: "\e[31m",
    blue: "\e[34m",
    green: "\e[32m",
    yellow: "\e[33m",
    cyan: "\e[36m",
    purple: "\e[35m",
    white: "\e[0m"
  }.freeze
  attr_reader :board, :row_pointer, :code_cracked, :players_role

  ROWS = 12
  COLUMNS = 5

  def initialize
    @board = Array.new(ROWS) { Array.new(COLUMNS) { |column| column < COLUMNS - 1 ? '●' : Array.new(4, ' ') } }
    @row_pointer = 11
    @code_cracked = false
    @players_role = ''
  end

  def print_board
    puts '_______________________'
    @board.each do |row|
      row.each_with_index do |element, elem_index|
        print(elem_index < row.length - 1 ? "| #{element} " : "| #{element[0]} #{element[1]} |\n________________|_#{element[2]}_#{element[3]}_|\n")
      end
      puts '_______________________'
    end
  end

  def insert_guess(guess)
    guess_splitted = guess.split(' ')
    (0..3).each do |c|
      @board[@row_pointer][c] = "#{COLORS[guess_splitted[c].to_sym]}#{@board[row_pointer][c]}#{COLORS[:white]}"
    end
  end

  def insert_key_pegs(key_pegs)
    key_peg_index = 0
    key_pegs.each do |key, value|
      value.times do
        @board[@row_pointer][4][key_peg_index] = "#{COLORS[key]}o#{COLORS[:white]}"
        key_peg_index += 1
      end
    end
    @row_pointer -= 1
  end

  def check_red_key_pegs
    @code_cracked = @board[@row_pointer + 1][4].all? { |element| element == "#{COLORS[:red]}o#{COLORS[:white]}" }
  end

  def set_players_role
    puts 'Do you want to plas as Codemaker or Codecracker?'
    puts 'Type "Codemaker" or "Codecracker": '
    loop do
      @players_role = gets.chomp
      break if /^(codecracker|codemaker)$/.match(@players_role.downcase)

      puts 'Wrong input, try again please: '
    end
    @players_role
  end
end
