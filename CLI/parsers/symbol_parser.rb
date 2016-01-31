class SymbolParser
  def initialize(delegate)
    @delegate = delegate
  end
  
  def arg_with(format)
    @delegate.options_with(format).empty? ? format.to_sym : nil
  end
  
  def options_with(format)
    {}
  end
end