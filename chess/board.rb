require 'singleton'
require_relative 'piece'
require 'byebug'

class Board

    attr_reader :rows, :sentinel

    def initialize
        @sentinel = NullPiece.instance
        @rows = Array.new(8) {Array.new(8) {@sentinel} }
        create_board
    end

    def move_piece(start_pos, end_pos)
        raise NoPieceException if self[start_pos].is_a?(NullPiece)
        raise InvalidMoveException if self[start_pos].moves.include?(end_pos)
        
        self[start_pos], self[end_pos] = self[end_pos], self[start_pos]
    end

    def [](pos)
        x, y = pos 
        self.rows[x][y]
    end

    def []=(pos, value)
        x, y = pos 
        self.rows[x][y] = value
    end

    def self.valid_pos?(pos)
        x, y = pos 
        x.between?(0,7) && y.between?(0,7)
    end

    private 


    # def valid_pos?(pos)
    #     x, y = pos
    #     selected_piece = self[pos]
    #     possible_moves = selected_piece.moves
    #     possible_moves = possible_moves.select { |pos| Board.in_board(pos) }

    #     result = []
    #     case self[pos].symbol
    #     when :Knight, :King
    #         possible_moves.each do |location|
    #             if self[location] == @sentinel || self[location].color != selected_piece.color
    #                 result.push(location)
    #             end
    #         end
    #     when :Queen, :Bishop, :Rook 
    #         possible_moves.sort_by! do |location|
    #             loc_x, loc_y = location
    #             (loc_x - x)**2 + (loc_y - y)**2
    #         end

    #         possible_moves.each do |location|
    #             new_x, new_y = location
    #             if new_x == x
    #                 if new_y > y
    #                     possible_moves.reject do |loc|
    #                         if loc_x == x ** 
    #                     end
    #                 end
    #             end

    #         end
    #     when :Pawn 

    #     end

    #     result.reject do |location|
    #         bewteen_possible_selected?(pos, location) 
    #     end

        
    # end

    # def bewteen_possible_selected?(cur_pos, new_pos)
    #     cur_x, cur_y = cur_pos
    #     new_x, new_y = new_pos
    #     if (cur_x == new_x) || (cur_y == new_y)
    #         if cur_x == new_x
    #             .eacj 
    #         end
    #     end
    # else (


        
    # end

    # def self.in_board(pos)
    #     x, y = pos 
    #     x.between?(0,7) && y.between?(0,7)
    # end
    
    def create_board
        self[[0,0]] = Rook.new("white", @rows, [0,0])
        self[[0,1]] = Knight.new("white", @rows, [0,1])
        self[[0,2]] = Bishop.new("white", @rows, [0,2])
        self[[0,3]] = Queen.new("white", @rows, [0,3])
        self[[0,4]] = King.new("white", @rows, [0,4])
        self[[0,5]] = Bishop.new("white", @rows, [0,5])
        self[[0,6]] = Knight.new("white", @rows, [0,6])
        self[[0,7]] = Rook.new("white", @rows, [0,7])

        self[[7,0]] = Rook.new("black", @rows, [7,0])
        self[[7,1]] = Knight.new("black", @rows, [7,1])
        self[[7,2]] = Bishop.new("black", @rows, [7,2])
        self[[7,3]] = Queen.new("black", @rows, [7,3])
        self[[7,4]] = King.new("black", @rows, [7,4])
        self[[7,5]] = Bishop.new("black", @rows, [7,5])
        self[[7,6]] = Knight.new("black", @rows, [7,6])
        self[[7,7]] = Rook.new("black", @rows, [7,7])

        @rows[1].map!.with_index do |piece, idx|
            Pawn.new("white", @rows, [1,idx])
        end

        @rows[6].map!.with_index do |piece, idx|
            Pawn.new("black", @rows, [6,idx])
        end
    end

end

class NoPieceException < StandardError; end 
class InvalidMoveException < StandardError; end