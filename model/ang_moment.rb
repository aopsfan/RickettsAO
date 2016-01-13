class AngMoment
  attr_accessor :l, :m, :n
  
  def initialize(l, m, n)
    @l = l
    @m = m
    @n = n
  end
  
  def quantum_number
    l + m + n
  end
  
  def character
    {0 => :s, 1 => :p, 2 => :d, 3 => :f}[quantum_number]
  end
  
  def symmetry
    "x"*@l + "y"*@m + "z"*@n
  end
  
  def ==(other)
    @l == other.l && @m == other.m && @n == other.n
  end
end