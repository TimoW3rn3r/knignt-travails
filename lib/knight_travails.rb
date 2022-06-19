require 'pry-byebug'

def draw_board(knight_position = nil)
  8.downto(1) do |row|
    1.upto(8) do |column|
      character = knight_position == [column, row] ? "\u265e" : "\u2800"
      print draw_box([column, row], character)
    end
    print "\n"
  end
end

def draw_box(position, character)
  (position.first + position.last).even? ? "\e[30;48;2;240;217;181m #{character} \e[m" : "\e[30;48;2;181;136;99m #{character} \e[m" # "\e[38;2;181;136;99m#{character}\e[m" : "\e[47;90m#{character}\e[m"
end

class Square
  attr_accessor :next_moves, :position, :parent

  def initialize(position, parent = nil)
    @position = position
    @next_moves = []
    @parent = parent
  end

  def serial_path
    node = self
    path = []
    while node
      path.unshift(node.position)
      node = node.parent
    end
    path
  end
end

class QueueItem
  attr_reader :position, :parent

  def initialize(position, parent = nil)
    @position = position
    @parent = parent
  end
end

class KnightMoves
  attr_reader :previous_moves, :start, :end_position

  def initialize(start_pos, end_pos)
    @previous_moves = [start_pos]
    @end_position = end_pos

    @start = build_tree([QueueItem.new(start_pos)])
  end

  def build_tree(queue)
    shifted = queue.shift
    position = shifted.position
    parent = shifted.parent
    square = Square.new(position, parent)
    parent.next_moves.append(square) if parent
    new_moves = all_moves(position).select { |move| new_move?(move) }
    return [] if new_moves.empty?

    new_moves.each do |move|
      @previous_moves << move
      queue.append(QueueItem.new(move, square))
    end
    build_tree(queue) until queue.empty?
    square
  end

  def shortest_path(queue = [start])
    shifted = queue.shift
    return shifted.serial_path if shifted.position == end_position

    queue += shifted.next_moves unless shifted.next_moves.empty?
    shortest_path(queue)
  end

  def all_moves(pos)
    x = pos[0]
    y = pos[1]
    moves = []
    # X+ and Y+
    moves << [x + 1, y + 2]
    moves << [x + 2, y + 1]
    # X- and Y+
    moves << [x - 1, y + 2]
    moves << [x - 2, y + 1]
    # X- and Y-
    moves << [x - 1, y - 2]
    moves << [x - 2, y - 1]
    # X+ and Y-
    moves << [x + 1, y - 2]
    moves << [x + 2, y - 1]
  end

  def new_move?(pos)
    !(out_of_bound?(pos) || duplicate_move?(pos))
  end

  def out_of_bound?(pos)
    pos.max > 8 || pos.min < 1 ? true : false
  end

  def duplicate_move?(pos)
    previous_moves.include?(pos)
  end
end

def rand_int(value, start = 0)
  (start + rand * (value - start)).to_i
end

def rand_pos
  [rand_int(8, 1), rand_int(8, 1)]
end

def knight_moves(start, stop)
  draw_board(start)
  knight = KnightMoves.new(start, stop)
  p knight.shortest_path
end

knight_moves(rand_pos, rand_pos)
# binding.pry
puts 'done'
