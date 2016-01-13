class BasisSetRow
  attr_accessor :alpha, :cc
  
  def initialize(first_character, components=[])
    @alpha = components[0]
    @cc = {}
    
    first_character_index = all_characters.index(first_character)
    valid_characters = all_characters.reject.with_index{|c, index| index < first_character_index}
    
    coefficients = components.reject.with_index{|c, index| index == 0}
    coefficients.each.with_index {|coefficient, index| @cc[valid_characters[index]] = coefficient}
  end
  
  def characters
    @cc.keys
  end
  
  def primitives_length(character=nil)
    character == nil || characters.include?(character) ? 1 : 0
  end
  
  def gaussian94_format
    ordered_cc = all_characters.map{|character| @cc[character]}.compact
    
    components = ["%e" % @alpha]
    components += ordered_cc.map {|coefficient| "%e" % coefficient}
    "\t" + components.join("\t\t")
  end
  
  private
  
  def all_characters
    BasisSet::CHARACTERS
  end
end