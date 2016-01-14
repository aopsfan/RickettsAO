# basis_set_partial_controller.rb
# 
# Controller for a basis set partial

class BasisSetPartialController
  
  # Property partial, an instance of BasisSetPartial
  attr_accessor :partial
  
  # Constant describing all theoretical angular momentum variations
  #   for each orbtial character
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
  
  # Initializer
  def initialize(partial)
    @partial = partial
  end
  
  # Generates all applicable atomic orbitals
  #   Returns all_angular_moments, mapped to a new array
  #   of single-zeta orbitals.
  def atomic_orbitals
    all_ang_moments.map do |ang_moment|
      orbital = AtomicOrbital.new(partial.n, ang_moment)
      orbital.add_basis_function(BasisFunction.new(@partial))
      orbital
    end
  end
  
  # name of the controller; same as that of its partial
  def name
    partial.name
  end
  
  private
  
  # An array containing all angular momentums for the orbital
  #   characters present in this controller.
  def all_ang_moments
    characters.reduce([]) do |memo, character|
      memo + ang_moments_with(character)
    end
  end
  
  # All angular momentum values for a given orbital character
  # Looks up the character in the ANG_MOMENTS_LOOKUP hash,
  #   and returns the value retrieved.
  def ang_moments_with(character)
    ang_moments = ANG_MOMENTS_LOOKUP[character]
    ang_moments ? ang_moments : []
  end
  
  # All orbital characters, retrieved from the partial
  def characters
    @partial.characters
  end
end