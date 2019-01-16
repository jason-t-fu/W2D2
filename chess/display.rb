require 'colorize'
require_relative 'board'
require_relative 'cursor'

PIECE_DISP = {
    Pawn: "P",
    Rook: "R",
    Knight: "N",
    Bishop: "B",
    Queen: "Q",
    King: "K",
    nil => " "
}

class Display

    attr_reader :board, :cursor
    def initialize(board)
        @board = board
        @cursor = Cursor.new([0, 0], board)
    end

    def render 
        puts "|-|-|-|-|-|-|-|-|"
        board.rows.each_with_index do |row, x|
            print "|"
            row.each_with_index do |piece, y|
                sym = PIECE_DISP[piece.symbol]
                
                square = case piece.color
                when "white"
                    sym.colorize(:color => :red)
                when "black"
                    sym.colorize(:color => :blue)
                when nil
                    " "
                end
                
                if [x,y] == cursor.cursor_pos
                    if cursor.selected
                        square = square.colorize(:background => :light_cyan)
                    else
                        square = square.colorize(:background => :cyan)
                    end
                end

                print square
                print "|"
            end
            puts
        end
        puts "|-|-|-|-|-|-|-|-|"
    end

    def test_move
        while true
            render 
            start_pos = cursor.get_input
            until start_pos
                render
                start_pos = cursor.get_input
            end
            render
            end_pos = cursor.get_input
            until end_pos
                render
                end_pos = cursor.get_input
            end
            board.move_piece(start_pos, end_pos)
        end
    end
end