require 'pry'
require 'string'
require 'direction'
require 'table'

class Robot

  def initialize
    @directions = [
      Direction.new('NORTH', 0, 1),
      Direction.new('EAST', 1, 0),
      Direction.new('SOUTH', 0, -1),
      Direction.new('WEST', -1, 0)
    ]
    @x = 0
    @y = 0
    @table = Table.new 5,5
  end

  attr_reader :x, :y, :table

  def direction
    @directions.first
  end

  def on_table? x, y
    return (x < @table.width and y < @table.height and x >= 0 and y >= 0)
  end

  def place x, y, direction
    return false if not self.on_table?(x, y) or not self.rotate_to(direction.upcase)
    @x = x
    @y = y

    return true
  end

  def report
    "#{@x},#{@y},#{self.direction}"
  end

  def move
    new_x = self.direction.x + @x
    new_y = self.direction.y + @y
    if self.on_table? new_x, new_y
      @x = new_x
      @y = new_y
    end
    self
  end

  def rotate_to direction
    i = @directions.find_index { |given_direction|
      given_direction.name == direction
    }
    if not i
      return false
    else
      @directions.rotate! i
      return true
    end
  end

  def right
    @directions.rotate!
    self
  end

  def left
    @directions.rotate!(-1)
    self
  end

  def handle_input(command_args)
    command, args = command_args.split ' '

    case command
    when 'PLACE'
      return if not args

      x, y, direction = args.split(',')

      if x.is_valid_integer? and y.is_valid_integer?
        x = x.to_i
        y = y.to_i
        self.place x, y, direction
      end
    when 'MOVE'
      self.move
    when 'LEFT'
      self.left
    when 'RIGHT'
      self.right
    when 'REPORT'
      self.report
    end

  end

end
