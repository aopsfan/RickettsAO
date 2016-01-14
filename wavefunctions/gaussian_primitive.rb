# gaussian_primitive.rb
# 
# Model for a single (uncontracted) Gaussian primitive, or GTO.

class GaussianPrimitive
  
  # Property alpha
  attr_accessor :alpha
  
  # Class instance variable for normalization
  @@normalize = false
  
  # Setter for the class instance variable
  def self.normalize=(normalize)
    @@normalize = normalize
  end
  
  # Initializer
  def initialize(alpha)
    @alpha = alpha
  end
  
  # The normalization part for the wavefunction, provided
  #   angular momentum. See equation (17).
  def n_constant(ang_moment)
    l = ang_moment.l
    m = ang_moment.m
    n = ang_moment.n
    
    pi_part  = (2.0 / Math::PI)**0.75
    num_part = 2.0**(l+m+n) * @alpha**((2.0*(l+m+n) + 3.0) / 4.0)
    den_part = semifact(l) * semifact(m) * semifact(n)
    
    pi_part * num_part / den_part**0.5
  end
  
  # The wavefunction for this Gaussian primitive
  # See equation 3.
  # Returns a block with a position parameter.
  # Copies many properties to avoid scoping issues.
  def wavefunction(ang_moment)
    l = ang_moment.l
    m = ang_moment.m
    n = ang_moment.n
    alpha = @alpha
    normalization = @@normalize ? n_constant(ang_moment) : 1
    
    lambda do |pos|
      ang_moment_part = pos.x**l * pos.y**m * pos.z**n
      ang_moment_part * normalization * exp(-1.0 * alpha * pos.r**2.0)
    end
  end
  
  private
  
  # exp(x) = e^x
  def exp(x)
    (Math::E) ** (x)
  end
  
  # semifact(x) = (2x - 1)!!
  def semifact(x)
    (1..x).reduce(1) do |memo, acc|
      memo * (2 * acc - 1)
    end
  end
end