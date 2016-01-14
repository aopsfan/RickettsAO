# basis_set_partial.rb
# 
# Model for a single "partial" or "shell" of a basis set

class BasisSetPartial
  
  # Properties n, rows
  # n is the principal quantum number
  # rows is an array of BasisSetRow instances
  attr_accessor :n, :rows
  
  # Initializer
  # Splits the first component (which is of the form "3 SP").
  #   The first part of this is assigned to n, and the first
  #   character of the second part of it is passed down to each
  #   BasisSetRow instance generated.
  # The rest of the components are used to populate the rows
  #   property.
  def initialize(components=[])
    shell = components[0].split(" ")
    @n = shell[0].to_i
    first_character = shell[1].split(//).first.downcase.to_sym
    
    row_components = components.reject.with_index{|c, index| index == 0}
    @rows = row_components.map{|component| BasisSetRow.new(first_character, component)}
  end
  
  # All orbital characters seen in this partial
  # Grabs the first row and returns its characters;
  #   all rows will have the same characters.
  def characters
    sample = @rows[0]
    sample.characters
  end
  
  # In Gaussian94 format, this is the first value in the header
  #   for this partial.
  def characterization
    characters.reduce("") {|a,b| a + b.to_s.capitalize}
  end
  
  # String dislosing principal quantum number (n) and orbital
  #   characters associated with this basis set partial.
  def name
    @n.to_s + characterization
  end
  
  # The number of rows using the specified character
  # Returns the sum of the primitives_length for this character
  #   given by each row.
  def primitives_length(character=nil)
    @rows.reduce(0) {|memo, row| memo + row.primitives_length(character)}
  end
  
  # The number of partials using the specified character
  # Returns 1 if character is nil or if the characters
  #   method returns an array which contains character
  def basis_functions_length(character)
    characters.include?(character) ? 1 : 0
  end
  
  # The Gaussian94 format for a basis set partial
  # Returns the appropriate header, then a joining of the
  #   Gaussian94 format for each of the rows.
  def gaussian94_format
    components = ["#{characterization}\t#{primitives_length}\t1.00"]
    @rows.each {|row| components << row.gaussian94_format}
    
    components.join("\n")
  end
end