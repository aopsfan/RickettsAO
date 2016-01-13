class AtomicOrbital
  attr_reader :basis_functions
  attr_accessor :ang_moment, :n
  
  @@normalize = false
  
  def self.normalize=(normalize)
    @@normalize = normalize
  end
  
  def initialize(n, ang_moment)
    @n = n
    @ang_moment = ang_moment
    @basis_functions = []
  end
  
  def add_basis_function(func)
    @basis_functions << func
  end
  
  def character
    ang_moment.character
  end
  
  def symmetry
    ang_moment.symmetry
  end
  
  def name
    [@n.to_s + character.to_s, symmetry].reject{|p| p == ""}.join("_")
  end
  
  def n_constant
    1.0 / basis_functions.length
  end
  
  def wavefunction
    normalization = @@normalize ? n_constant : 1
    basis_functions = @basis_functions.dup
    
    lambda do |pos|
      normalization * basis_functions.reduce(0.0) do |memo, func|
        memo + func.wavefunction(@ang_moment).call(pos)
      end
    end
  end
  
  def to_s
    "#{name} orbital: x^#{ang_moment.l} y^#{ang_moment.m} z^#{ang_moment.n}, #{basis_functions.length} function(s):\n" + 
    basis_functions.map{|function| "\t\t" + function.to_s}.join(",\n")
  end
end