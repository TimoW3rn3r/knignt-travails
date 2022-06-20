require_relative 'lib/knight_travails'
include Constants

def rand_int(value, start = 0)
  (start + rand * (value - start)).to_i
end

def rand_pos
  [rand_int(BOX_START, BOX_END), rand_int(BOX_START, BOX_END)]
end

def knight_moves(start, stop)
  knight = KnightMoves.new(start, stop)
  knight.shortest_path
end

knight_moves(rand_pos, rand_pos)
knight_moves([5, 2], [6, 1])
knight_moves([1, 1], [2, 1])
knight_moves([1, 1], [4, 4])
knight_moves([4, 4], [1, 1])