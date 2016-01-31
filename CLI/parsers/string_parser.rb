class StringParser
  def arg_with(format)
    valid = format[0] == "'" && format[-1] == "'"
    valid ? format[1..-2] : nil
  end
  
  def options_with(format)
    {}
  end
end