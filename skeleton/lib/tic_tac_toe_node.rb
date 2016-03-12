require_relative 'tic_tac_toe'

class TicTacToeNode
   def initialize(board, next_mover_mark, prev_move_pos = nil)
     @board = board
     @next_mover_mark = next_mover_mark
     @prev_move_pos = prev_move_pos
   end

   def losing_node?(evaluator)
      opponent_move = (evaluator == :x ? :o : :x)
      return true if @board.winner == opponent_move
      return nil if @board.winner.nil? || @board.winner == evaluator

      if @next_mover_mark == evaluator
         self.children.all? { |child| child.losing_node?(evaluator) }
      else
         self.children.any? { |child| child.losing_node?(opponent_move) }
      end
   end

   def winning_node?(evaluator)
      opponent_move = (evaluator == :x ? :o : :x)
      return true if @board.winner == evaluator
      return nil if @board.winner.nil? || @board.winner == opponent_move

      if @next_mover_mark == evaluator
         self.children.any? { |child| child.winning_node?(evaluator) }
      else
         self.children.all? { |child| child.losing_node?(opponent_move) }
      end
   end

   # This method generates an array of all moves that can be made after
   # the current move.
   def children
      children = []
      @board.each_with_index do |row, i|
         row.each_with_index do |cell, j|
            if cell.nil?
               child_board = @board.dup
               child_board[[i, j]] = @next_mover_mark
               @next_mover_mark = @next_mover_mark == :x ? :o : :x
               children << TicTacToeNode.new(child_board, next_mover_mark, [i, j])
            end
         end
      end

   end
end
