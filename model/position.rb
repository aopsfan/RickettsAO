# position.rb
#
# Model for a point in Cartesian space

class Position
  
  # Properties x, y, and z
  attr_accessor :x, :y, :z
  
  # Initializer
  # If only one value is provided, it is treated as the x-
  #   coordinate, and y and z are set to 0.
  def initialize(x, y=0.0, z=0.0)
    @x = x
    @y = y
    @z = z
  end
  
  # r using the distance formula
  def r
    return (x**2.0 + y**2.0 + z**2.0)**0.5
  end
end
