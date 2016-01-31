class KeyValueParser
  def initialize(delegate)
    @delegate = delegate
  end
  
  def arg_with(format)
    nil
  end
  
  def options_with(format)
    parts = format.split('=')
    parts.length == 2 ? {arg_with_part(parts[0]) => arg_with_part(parts[1])} : {}
  end
  
  private
  
  def arg_with_part(part)
    @delegate.arg_with(part)
  end
end