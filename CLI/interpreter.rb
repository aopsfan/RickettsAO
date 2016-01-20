class Interpreter
  attr_accessor :delegate
  
  def initialize(delegate)
    @delegate = delegate
  end
  
  def execute(console, line) # -> "load_basis_set basis_set=STO-3G element=H"
    parts = line.split(' ') # ["load_basis_set", "basis_set=STO-3G", "element=H"]
    command_key = parts[0].to_sym # :load_basis_set
    arg_formats = parts.reject.with_index {|p, index| index == 0} # ["basis_set=STO-3G", "element=H"]
    delegate.send(command_key, console, arguments_with(arg_formats))
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
  
  def arguments_with(arg_formats) # -> ["basis_set=STO-3G", "element=H"]
    hash_array = arg_formats.map{|arg| arg.split('=')} # [["basis_set", "STO-3G"], ["element", "H"]] 
    hash_array.reduce({}) {|memo, acc| memo[acc[0].to_sym] = parse(acc[1]); memo} # {:basis_set => "STO-3G", :element => "H"} ->
  end
end