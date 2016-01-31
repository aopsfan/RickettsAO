class BooleanParser
  def arg_with(format)
    {'true' => true, 'false' => false}[format]
  end
  
  def options_with(format)
    prefix_values = {':' => true, '!' => false}
    value = prefix_values[format[0]]
    option = format[1..-1]
    
    value == nil ? {} : {option => value}
  end
end