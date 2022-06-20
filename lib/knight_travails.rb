module Constants
  BOX_START = 1
  BOX_END = 8
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

class KnightMoves
  include Constants

  attr_reader :start_position, :end_position
  attr_accessor :previous_moves, :queue

  def initialize(start_pos, end_pos)
    @previous_moves = [start_pos]
    @end_position = end_pos
    @start_position = start_pos
    @queue = []
  end

  def shortest_path
    puts "\nFind path for: #{start_position} -> #{end_position}"
    queue << Square.new(start_position)
    moves = find.serial_path
    puts "You made it in #{moves.size - 1} moves! Here's your path:"
    moves.each do |move|
      p move
      draw_board(move)
    end
    p moves
  end

  def find
    square = queue.shift
    return square if square.position == end_position

    new_moves = all_moves(square.position).select { |move| new_move?(move) }
    populate_queue(new_moves, square)
    find
  end

  def populate_queue(moves, parent)
    moves.each do |move|
      previous_moves << move
      queue << Square.new(move, parent)
    end
  end

  def all_moves(pos)
    moves = []
    numbers = [1, 2]
    operations = [->(a, b) { a + b }, ->(a, b) { a - b }] # [add, subtract]

    numbers
      .product(numbers)
      .select { |array| array.uniq.length == 2 }
      .product(operations)
      .product(operations)
      .map(&:flatten)
      .each do |combination|
      moves << [combination[2].call(pos[0], combination[0]),
                combination[3].call(pos[1], combination[1])]
    end

    moves
  end

  def new_move?(pos)
    !(out_of_bound?(pos) || duplicate_move?(pos))
  end

  def out_of_bound?(pos)
    pos.max > BOX_END || pos.min < BOX_START
  end

  def duplicate_move?(pos)
    previous_moves.include?(pos)
  end

  def draw_board(knight_position = nil)
    BOX_END.downto(BOX_START) do |row|
      BOX_START.upto(BOX_END) do |column|
        character = knight_position == [column, row] ? "\u265e" : "\u2800"
        print draw_box([column, row], character)
      end
      print "\n"
    end
  end

  def draw_box(position, character)
    return "\e[30;48;2;240;217;181m #{character} \e[m" if (position.first + position.last).even?

    "\e[30;48;2;181;136;99m #{character} \e[m"
  end
end
