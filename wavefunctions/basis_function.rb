class BasisFunction
  attr_accessor :partial
  
  @@normalize = false
  
  def self.normalize=(normalize)
    @@normalize = normalize
  end
  
  def initialize(partial)
    @partial = partial
  end
  
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
  
  def to_s
    "function: #{partial.rows.length} Gaussians"
  end
  
  private
  
  def semifact(x)
    (1..x).reduce(1) do |memo, acc|
      memo * (2 * acc - 1)
    end
  end
end

class Float
  def signif(signs)
    Float("%.#{signs}g" % self)
  end
end