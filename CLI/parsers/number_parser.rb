class NumberParser
  def arg_with(format)
    # don't look...
    Integer(format) rescue Float(format) rescue nil
  end
  
  def options_with(format)
    {}
  end
end