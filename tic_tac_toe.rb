require 'colorize'
require_relative 'cursorable'
require_relative 'board'

class TicTacToe
  class IllegalMoveError < RuntimeError
  end

  attr_reader :board, :players, :turn

  def initialize(player1, player2)
    @board = Board.new
    @players = { :x => player1, :o => player2 }
    @turn = :x
  end

  def run
    until self.board.over?
      play_turn
    end

    if self.board.won?
      winning_player = self.players[self.board.winner]
      puts "#{winning_player.name} won the game!"
    else
      puts "No one wins!"
    end
  end

  def show(*cursor_pos)
     @cursor_pos = cursor_pos
    board.rows.each_with_index do |row, i|
      puts " #{show_row(row, i).join(" ")}"
    end
  end

   def show_row(row, i)
      row.each_with_index do |cell, j|
         if cell.nil?
            cell = " "
         elsif cell == :x
            cell = cell.to_s.colorize({color: :red})
         elsif cell == :o
            cell = cell.to_s.colorize({color: :blue})
         end
         cell = cell.colorize({background: :white}) if [i, j] == @cursor_pos
      end
   end

  private
  def place_mark(pos, mark)
    if self.board.empty?(pos)
      self.board[pos] = mark
      true
    else
      false
    end
  end

  def play_turn
    loop do
      current_player = self.players[self.turn]
      pos = current_player.move(self, self.turn)
      break if place_mark(pos, self.turn)
    end

    @turn = ((self.turn == :x) ? :o : :x)
  end
end

class HumanPlayer
  include Cursorable

  attr_reader :name

  def initialize(name)
    @name = name
    @cursor_pos = [0, 0]
  end

  def move(game, mark)
    pos = nil
    until pos
      system('clear')
      game.show(@cursor_pos)
      puts "#{@name}: please move the cursor(WASD), and press enter."
      pos = get_input
    end

    return pos
  end

  private
  def self.valid_coord?(pos)
    pos.all? { |coord| (0..2).include?(coord) }
  end
end

class ComputerPlayer
  attr_reader :name

  def initialize
    @name = "Robot"
  end

  def move(game, mark)
    winner_move(game, mark) || random_move(game)
  end

  private
  def winner_move(game, mark)
    (0..2).each do |row|
      (0..2).each do |col|
        board = game.board.dup
        pos = [row, col]

        next unless board.empty?(pos)
        board[pos] = mark

        return pos if board.winner == mark
      end
    end

    nil
  end

  def random_move(game)
    board = game.board
    while true
      range = (0..2).to_a
      pos = [range.sample, range.sample]

      return pos if board.empty?(pos)
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the dumb computer!"
  hp = HumanPlayer.new("Player1")
  cp = ComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
