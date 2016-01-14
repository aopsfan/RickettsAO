# ang_moment.rb
# 
# Model for angular momentum

class AngMoment
  
  # Properties l, m, and n
  attr_accessor :l, :m, :n
  
  # Initializer
  def initialize(l, m, n)
    @l = l
    @m = m
    @n = n
  end
  
  # The angular momentum quantum number, usually denoted L
  # Returns the sum of l, m, and n
  def quantum_number
    @l + @m + @n
  end
  
  # The character of an orbital with this angular momentum
  # Creates a hash pointing quantum numbers to character symbols,
  #   then returns the value of the hash for this quantum number.
  def character
    {0 => :s, 1 => :p, 2 => :d, 3 => :f}[quantum_number]
  end
  
  # A string which serves as a good way to identify angular momentum
  # For an AngMoment object with l = 2, m = 1, and n = 0, symmetry
  #   returns "xxy".
  def symmetry
    "x"*@l + "y"*@m + "z"*@n
  end
  
  # Determines whether this object is equivalent to another
  #   AngMoment instance
  def ==(other)
    @l == other.l && @m == other.m && @n == other.n
  end
end