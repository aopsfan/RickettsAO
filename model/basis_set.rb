# basis_set.rb
# 
# Model for an entire basis set

class BasisSet
  
  # Properties name, partials, element
  # name is simply the name of the basis set, i. e. "6-311G"
  # element is the symbol for an element on the Periodic Table
  # partials is a list of BasisSetPartial instances
  attr_accessor :name, :partials, :element
  
  # Constant listing orbital characters in order from smallest
  #   to largest angular momentum
  CHARACTERS = [:s, :p, :d, :f]
  
  # Initializer
  # Sets element to first component, and maps following components
  #   to BasisSetPartial elements, which are then added to the
  #   partials array.
  def initialize(name, components=[])
    @name = name
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
  
  def characters
    BasisSet::CHARACTERS.select do |character|
      valid = basis_functions_length(character) > 0
      yield(character) if block_given? && valid # avoid iterating over arrays twice
      valid
    end
  end
  
  # String representing total number of primitives and the
  #   total number of basis functions for each orbital character
  #   in the basis set.
  # Returns a string based on primitives_length,
  #   basis_functions_length, and BasisSet::CHARACTERS.
  def contraction
    primitives = []
    characters do |character|
      primitives << "#{primitives_length(character)}#{character.to_s}"
    end
    
    basis_functions = []
    characters do |character|
      basis_functions << "#{basis_functions_length(character)}#{character.to_s}"
    end
    
    "(#{primitives.join(',')}) -> [#{basis_functions.join(',')}]"
  end
  
  def to_s
    [name, element, contraction].join(", ")
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