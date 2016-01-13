class BasisSetPartial
  attr_accessor :n, :rows
  
  def initialize(components=[])
    shell = components[0].split(" ")
    @n = shell[0].to_i
    first_character = shell[1].split(//).first.downcase.to_sym
    
    row_components = components.reject.with_index{|c, index| index == 0}
    @rows = row_components.map{|component| BasisSetRow.new(first_character, component)}
  end
  
  def characters
    sample = @rows[0]
    sample.characters
  end
  
  def characterization
    characters.reduce("") {|a,b| a + b.to_s.capitalize}
  end
  
  def name
    @n.to_s + characterization
  end
  
  def primitives_length(character=nil)
    @rows.reduce(0) {|memo, row| memo + row.primitives_length(character)}
  end
  
  def basis_functions_length(character)
    characters.include?(character) ? 1 : 0
  end
  
  def gaussian94_format
    components = ["#{characterization}\t#{primitives_length}\t1.00"]
    @rows.each {|row| components << row.gaussian94_format}
    
    components.join("\n")
  end
end