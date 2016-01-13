class Position
  attr_accessor :x, :y, :z
  
  def initialize(x, y=0.0, z=0.0)
    @x = x
    @y = y
    @z = z
  end
  
  def r
    return (x**2.0 + y**2.0 + z**2.0)**0.5
  end
end
