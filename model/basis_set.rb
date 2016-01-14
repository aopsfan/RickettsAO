# basis_set.rb
# 
# Model for an entire basis set

class BasisSet
  
  # Properties partials, element
  # element is the symbol for an element on the Periodic Table
  # partials is a list of BasisSetPartial instances
  attr_accessor :partials, :element
  
  # Constant listing orbital characters in order from smallest
  #   to largest angular momentum
  CHARACTERS = [:s, :p, :d, :f]
  
  # Initializer
  # Sets element to first component, and maps following components
  #   to BasisSetPartial elements, which are then added to the
  #   partials array.
  def initialize(components=[])
    @element = components[0]
    partial_components = components.reject.with_index{|c, index| index == 0}
    @partials = partial_components.map {|component| BasisSetPartial.new(component)}
  end
  
  # The number of rows (within partials) using the specified
  #   character
  # Returns the sum of the primitives_length for this character
  #   given by each partial.
  def primitives_length(character)
    @partials.reduce(0) {|memo, partial| memo + partial.primitives_length(character)}
  end
  
  # The number of partials using the specified character
  # Returns the sum of the basis_functions_length for this
  #   character given by each partial.
  def basis_functions_length(character)
    @partials.reduce(0) {|memo, partial| memo + partial.basis_functions_length(character)}
  end
  
  # String representing total number of primitives and the
  #   total number of basis functions for each orbital character
  #   in the basis set.
  # Returns a string based on primitives_length,
  #   basis_functions_length, and BasisSet::CHARACTERS.
  def contraction
    characters = BasisSet::CHARACTERS
    
    primitives = characters.reduce([]) do |memo, character|
      length = primitives_length(character)
      length == 0 ? memo : memo << "#{length}#{character.to_s}"
    end
    
    basis_functions = characters.reduce([]) do |memo, character|
      length = basis_functions_length(character)
      length == 0 ? memo : memo << "#{length}#{character.to_s}"
    end
    
    "(#{primitives.join(',')}) -> [#{basis_functions.join(',')}]"
  end
  
  # The Gaussian94 format for the entire basis set
  # Returns the appropriate header and footer, with a
  #   joining of the Gaussian94 format for each of the partials
  #   in between.
  def gaussian94_format
    components = ["****"]
    components << "#{element}\t0"
    @partials.each {|partial| components << partial.gaussian94_format}
    components << "****"
    
    components.join("\n")
  end
end