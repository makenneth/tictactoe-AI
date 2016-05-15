require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
     new_node = TicTacToeNode.new(game.board, mark)
     new_node_children = new_node.children.shuffle
     new_node_children.each do |child|
        return child.prev_move_pos if child.winning_node?(mark)
     end

     new_node_children.each do |child|
        return child.prev_move_pos unless child.losing_node?(mark)
     end

     raise "No non-losing nodes Error"
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Player1")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
