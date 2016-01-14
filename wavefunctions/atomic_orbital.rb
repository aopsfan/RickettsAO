# atomic_orbital.rb
# 
# Model for an entire Atomic Orbital, comprising one or more basis
#   functions.

class AtomicOrbital
  
  # Properties basis_functions, ang_moment, and n
  attr_reader :basis_functions
  attr_accessor :ang_moment, :n
  
  # Class instance variable for normalization
  @@normalize = false
  
  # Setter for the class instance variable
  def self.normalize=(normalize)
    @@normalize = normalize
  end
  
  # Initializer
  # Assigns the expected properties, and initializes and empty
  #   basis_functions array.
  def initialize(n, ang_moment)
    @n = n
    @ang_moment = ang_moment
    @basis_functions = []
  end
  
  # Adds the inputted instance of BasisFunction to basis_functions
  def add_basis_function(func)
    @basis_functions << func
  end
  
  # The orbital's character, derived from the angular momentum
  def character
    ang_moment.character
  end
  
  # The orbital's symmetry, derived from the angular momentum
  def symmetry
    ang_moment.symmetry
  end
  
  # A name for the orbital, i.e. 2p_x
  # Returns the principal quantum number plus the character,
  #   and the symmetry of the orbital, when it's not an empty
  #   string.
  def name
    [@n.to_s + character.to_s, symmetry].reject{|p| p == ""}.join("_")
  end
  
  # The normalization part of the atomic orbital.
  # Returns the reciprocal of the number of basis functions, thus
  #   weighting them all equally.
  def n_constant
    1.0 / basis_functions.length
  end
  
  # The wavefunction for this atomic orbital.
  # Returns a block with a position parameter, which sums the
  #   wavefunctions of all "subsidiary" basis functions.
  # Copies a few properties to avoid scoping issues.
  def wavefunction
    normalization = @@normalize ? n_constant : 1
    basis_functions = @basis_functions.dup
    
    lambda do |pos|
      normalization * basis_functions.reduce(0.0) do |memo, func|
        memo + func.wavefunction(@ang_moment).call(pos)
      end
    end
  end
  
  # String representation of this orbital, including name,
  #   angular momentum, number of functions, and the string
  #   representations of each of the functions.
  def to_s
    "#{name} orbital: x^#{ang_moment.l} y^#{ang_moment.m} z^#{ang_moment.n}, #{basis_functions.length} function(s):\n" + 
    basis_functions.map{|function| "\t\t" + function.to_s}.join(",\n")
  end
end