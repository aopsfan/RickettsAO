class BasisSet
  attr_accessor :partials, :element
  
  CHARACTERS = [:s, :p, :d, :f]
  
  def initialize(components=[])
    @element = components[0]
    partial_components = components.reject.with_index{|c, index| index == 0}
    @partials = partial_components.map {|component| BasisSetPartial.new(component)}
  end
  
  def primitives_length(character)
    @partials.reduce(0) {|memo, partial| memo + partial.primitives_length(character)}
  end
  
  def basis_functions_length(character)
    @partials.reduce(0) {|memo, partial| memo + partial.basis_functions_length(character)}
  end
  
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
  
  def gaussian94_format
    components = ["****"]
    components << "#{element}\t0"
    @partials.each {|partial| components << partial.gaussian94_format}
    components << "****"
    
    components.join("\n")
  end
end