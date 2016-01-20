# basis_function.rb
# 
# Model for a basis function (single-zeta) of contracted Gaussians.

class BasisFunction
  
  # Property for partial (an instance of BasisSetPartial)
  attr_accessor :partial
  
  # Class instance variable for normalization
  @@normalize = false
  
  # Setter for the class instance variable
  def self.normalize=(normalize)
    @@normalize = normalize
  end
  
  # Initializer
  def initialize(partial)
    @partial = partial
  end
  
  # The normalization part for the wavefunction, provided
  #   angular momentum. See equation (18).
  def n_constant(ang_moment)
    l = ang_moment.l
    m = ang_moment.m
    n = ang_moment.n
    n_length = @partial.primitives_length(ang_moment.character) - 1
    
    cc = lambda {|index| @partial.rows[index].cc[ang_moment.character]}
    alpha = lambda {|index| @partial.rows[index].alpha}
    
    semifact_part = Math::PI**1.5 * semifact(l) * semifact(m) * semifact(n) / (2.0**ang_moment.quantum_number)
    sum_part = (0..n_length).reduce(0.0) do |memo_i, i|
      memo_i + (0..n_length).reduce(0.0) do |memo_j, j|
        memo_j + cc.call(i) * cc.call(j) / ((alpha.call(i) + alpha.call(j)) ** (ang_moment.quantum_number + 1.5))
      end
    end
    
    (semifact_part * sum_part) ** -0.5
  end
  
  # The wavefunction for this basis function.
  # See equation 4.
  # Returns a block with a position parameter.
  # Copies many properties to avoid scoping issues.
  def wavefunction(ang_moment)
    partial = @partial.dup
    normalization = @@normalize ? n_constant(ang_moment) : 1
    
    lambda do |pos|
      normalization * partial.rows.reduce(0.0) do |memo, row|
        gaussian = GaussianPrimitive.new(row.alpha)
        memo + row.cc[ang_moment.character] * gaussian.wavefunction(ang_moment).call(pos)
      end
    end
  end
  
  # String representation of this function, relaying the number
  #   of Gaussians.
  def to_s
    "function: #{partial.rows.length} Gaussians"
  end
  
  private
  
  # semifact(x) = (2x - 1)!!
  def semifact(x)
    (1..x).reduce(1) do |memo, acc|
      memo * (2 * acc - 1)
    end
  end
end