# frozen_string_literal: true

require_relative './board'
require_relative './codemaker'
require_relative './codecracker'

board = Board.new
codecracker = Codecracker.new

board.set_players_role

board.print_board

if board.players_role.capitalize == 'Codecracker'
  codemaker = ComputerCodemaker.new
  codemaker.set_code
  until board.code_cracked || board.row_pointer == -1
    board.insert_guess(codecracker.guess_code)

    board.insert_key_pegs(codemaker.check_guess(codecracker.guess.split(' ')))
    board.print_board
    board.check_red_key_pegs
  end

else
  codemaker = PlayerCodemaker.new
  codemaker.set_code
  until board.code_cracked || board.row_pointer == -1

    board.insert_guess(codecracker.generate_first_guess) if board.row_pointer == 11

    if board.row_pointer < 11
      codecracker.count_key_pegs(board.board, board.row_pointer)
      codecracker.append_correct_colors

      board.insert_guess(codecracker.present_colors.length == 4 ? codecracker.shuffle_guess : codecracker.generate_guess)

    end

    board.insert_key_pegs(codemaker.check_guess(codecracker.guess.split(' ')))
    board.print_board
    board.check_red_key_pegs
  end
end
puts "Codemaker has won! Secret code is #{codemaker.code.join(' ')}" unless board.code_cracked
puts "Codecracker has won! Secret code is #{codemaker.code.join(' ')}" if board.code_cracked
