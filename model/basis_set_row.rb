# basis_set_row.rb
# 
# Model for a single row of values in a basis set

class BasisSetRow
  
  # Properties alpha, cc
  # cc is a hash, mapping orbital characters to contraction
  #   coefficients
  attr_accessor :alpha, :cc
  
  # Initializer
  # Sets alpha to first component, and assigns following components
  #   to the cc hash.
  # first_character specifies the lowest angular momentum/character
  #   to be used as a key in the cc hash.
  def initialize(first_character, components=[])
    @alpha = components[0]
    @cc = {}
    
    first_character_index = all_characters.index(first_character)
    valid_characters = all_characters.reject.with_index{|c, index| index < first_character_index}
    
    coefficients = components.reject.with_index{|c, index| index == 0}
    coefficients.each.with_index {|coefficient, index| @cc[valid_characters[index]] = coefficient}
  end
  
  # All orbital characters seen in this row
  def characters
    @cc.keys
  end
  
  # The number of rows using the specified character
  # Returns 1 if character is nil or if the characters
  #   method returns an array which contains character
  def primitives_length(character=nil)
    character == nil || characters.include?(character) ? 1 : 0
  end
  
  # The Gaussian94 format for a single row
  # Returns a tab character ("\t"), then a double-tab-
  #   delimited joining of alpha and the values of the cc hash
  def gaussian94_format
    ordered_cc = all_characters.map{|character| @cc[character]}.compact
    
    components = ["%e" % @alpha]
    components += ordered_cc.map {|coefficient| "%e" % coefficient}
    "\t" + components.join("\t\t")
  end
  
  private
  
  # Retrieve the constant array of orbital characters from BasisSet
  def all_characters
    BasisSet::CHARACTERS
  end
end