class BasisSetPartialController
  attr_accessor :partial
  
  ANG_MOMENTS_LOOKUP = {
    s: [
      AngMoment.new(0, 0, 0)
    ],
    p: [
      AngMoment.new(1, 0, 0),
      AngMoment.new(0, 1, 0),
      AngMoment.new(0, 0, 1)
    ],
    d: [
      AngMoment.new(2, 0, 0),
      AngMoment.new(1, 1, 0),
      AngMoment.new(1, 0, 1),
      AngMoment.new(0, 2, 0),
      AngMoment.new(0, 1, 1),
      AngMoment.new(0, 0, 2)
    ],
    f: [
      AngMoment.new(3, 0, 0),
      AngMoment.new(1, 2, 0),
      AngMoment.new(1, 0, 2),
      AngMoment.new(1, 1, 1),
      AngMoment.new(2, 1, 0),
      AngMoment.new(2, 0, 1),
      AngMoment.new(0, 2, 1),
      AngMoment.new(0, 1, 2),
      AngMoment.new(0, 3, 0),
      AngMoment.new(0, 0, 3)
    ]
  }
  
  def initialize(partial)
    @partial = partial
  end
  
  def atomic_orbitals
    all_ang_moments.map do |ang_moment|
      orbital = AtomicOrbital.new(partial.n, ang_moment)
      orbital.add_basis_function(BasisFunction.new(@partial))
      orbital
    end
  end
  
  def name
    partial.name
  end
  
  private
  
  def all_ang_moments
    characters.reduce([]) do |memo, character|
      memo + ang_moments_with(character)
    end
  end
    
  def ang_moments_with(character)
    ang_moments = ANG_MOMENTS_LOOKUP[character]
    ang_moments ? ang_moments : []
  end
  
  def characters
    @partial.characters
  end
end