class Interpreter
  attr_accessor :delegate
  
  def execute(line) # -> "attach STO-3G H true"
    parts = line.split(' ') # ["attach", "STO-3G", "H", "true"]
    command_key = parts[0].to_sym # :attach
    arg_formats = parts.reject.with_index {|p, index| index == 0} # ["STO-3G", "H", "true"]
    delegate.send(command_key, *arg_formats.map{|arg| parse(arg)}) # ["STO-3G", "H", true]
  end
  
  private
  
  def parse(format)
    if format == "true"
      true
    elsif format == "false"
      false
    else
      format
    end
  end
end