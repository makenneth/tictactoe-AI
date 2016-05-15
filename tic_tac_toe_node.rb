require_relative 'tic_tac_toe'

class TicTacToeNode
   attr_reader :prev_move_pos, :board, :next_mover_mark

   def initialize(board, next_mover_mark, prev_move_pos = nil)
     @board = board
     @next_mover_mark = next_mover_mark
     @prev_move_pos = prev_move_pos
   end

   def losing_node?(evaluator)
      opponent_move = (evaluator == :x ? :o : :x)

      return board.won? && board.winner != evaluator if board.over?


      if @next_mover_mark == evaluator
         self.children.all? { |child| child.losing_node?(evaluator) }
      else
         self.children.any? { |child| child.losing_node?(evaluator) }
      end
   end

   def winning_node?(evaluator)
      opponent_move = (evaluator == :x ? :o : :x)

      return board.winner == evaluator if board.over?

      if @next_mover_mark == evaluator
         self.children.any? { |child| child.winning_node?(evaluator) }
      else
         self.children.all? { |child| child.winning_node?(evaluator) }
      end
   end

   def children
      children = []
      @board.rows.each_with_index do |row, i|
         row.each_with_index do |cell, j|
            next unless cell.nil?
            child_board = @board.dup
            child_board[[i, j]] = @next_mover_mark
            alternate_mover_mark = @next_mover_mark == :x ? :o : :x
            children << TicTacToeNode.new(child_board, alternate_mover_mark, [i, j])
         end
      end
      children
   end
end
