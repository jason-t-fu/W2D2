require 'singleton'

module SteppingPiece

    def moves
        poss_moves = []
        x, y = pos
        
        self.move_diffs.map do |diff|
            dx, dy = diff
            poss_move = [x + dx, y + dy]
            if !Board.valid_pos?(poss_move)
                next
            elsif board[poss_move] == board.sentinel || board[poss_move].color != self.color
                poss_moves.push(location)
            else
                next
            end
        end
    end

end

module SlidingPiece
    
    def moves 
        poss_moves = []
        x, y = pos
        self.move_dirs.each do |dir|
            (1..7).each do |mult|
                dx, dy = dir
                poss_move = [x + mult * dx, y + mult * dy]
                if !Board.valid_pos?(poss_move)
                    break
                elsif board[poss_move].color != self.color
                    poss_moves << poss_move
                    break
                elsif board[poss_move].color == self.color
                    break
                else
                    poss_moves << poss_move
                end
            end
        end
        poss_moves
    end

    def horizontal_dirs 
        HORIZONTAL_DIRS
    end

    def diagonal_dirs
        DIAGONAL_DIRS
    end

    private
    HORIZONTAL_DIRS = [[0,1],[1,0],[0,-1],[-1,0]]

    DIAGONAL_DIRS = [[-1,-1],[-1,1],[1,-1],[1,1]]
end

class Piece

    attr_reader :pos, :color, :board

    def initialize(color, board, pos)
        @color = color
        @board = board 
        @pos = pos
    end

    def moves

    end

    def symbol 
        self.class.to_s.to_sym
    end

end

class NullPiece < Piece 
    include Singleton

    def initialize
    end

    def color 
    end
    
    def symbol
        nil
    end

end

class Bishop < Piece 
    include SlidingPiece

    def move_dirs
        diagonal_dirs
    end
end

class Rook < Piece 
    include SlidingPiece

    def move_dirs
        horizontal_dirs
    end

end

class Queen < Piece 
    include SlidingPiece

    def move_dirs
        horizontal_dirs + diagonal_dirs
    end

end

class Knight < Piece 
    include SteppingPiece

    def move_diffs
        poss_moves = []
        [-2, -1, 1, 2].each do |x|
            [-2, -1, 1, 2].each do |y|
                next if x.abs == y.abs
                poss_moves << [x, y]
            end
        end
        poss_moves   
    end
end

class King < Piece 
    include SteppingPiece

    def move_diffs
        poss_moves = []
        (-1..1).each do |x|
            (-1..1).each do |y|
                next if x == 0 && y == 0
                poss_moves << [x, y]
            end
        end
        poss_moves                         
    end
end

class Pawn < Piece 
    include SteppingPiece

    def symbol
        :Pawn
    end

    def move_dirs
        forward_steps + side_attacks
    end

    private

    def at_start_row?
        x, y = pos
        case self.color
        when "white"
            return true if y == 1
        when "black"
            return true if y == 6
        end
        false
    end

    def forward_dir
        case self.color
        when "white"
            return 1
        when "black"
            return -1
        end
    end

    def forward_steps
        x, y = pos
        moves = [[0, forward_dir]]
        moves << [0, 2 * forward_dir] if at_start_row?
        moves
    end

    def side_attacks
        [[-1, forward_dir], [1, forward_dir]]
    end
end
