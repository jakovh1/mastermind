# Mastermind

## Description
A Ruby implementation of the Mastermind board game. Crack the code in 12 turns or less to win!

## Installation
1. Clone the repository
2. Run `ruby game.rb`
3. Follow the on-screen instructions
4. Enjoy!

## Usage
The game will prompt you whether you want to play as Codemaker or Codecracker.
The gameflow differs depending on your choice:

### 1. Codecracker:
      - Computer generates a secret code.
      - Write a guess which is comprised of 4 colors. (The guess can include the same color multiple times)
      - Check key pegs (red and white circles) to verify the accuracy of your guess.
      - Red pegs represent correct colors in the correct position, and white pegs represent correct colors in the wrong position.
      - Write a new guess according to key pegs.
      - Repeat steps above until the code is cracked.
### 2. Codemaker:
      - Write a secret code which is comprised of 4 colors. (The secret code can include the same color multiple times)
      - Allow the computer to crack the secret code.