class Direction
  def initialize(name, x, y)
    @name = name
    @x = x
    @y = y
  end

  attr_reader :name, :x, :y

  def to_s
    @name
  end
end
