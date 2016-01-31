class Interpreter
  attr_accessor :delegate
  
  def initialize
    @parser = SingleFormatParser.new
  end
  
  def execute(line)
    parts = line.split(' ')
    command = parts[0].to_sym
    arg_formats = parts.reject.with_index {|p, index| index == 0}
    
    args = arg_formats.map{|format| @parser.arg_with(format)}.compact
    options = arg_formats.reduce({}) {|memo, format| memo.merge(@parser.options_with(format))}
    
    params = args + [options]
    
    @delegate.send(command, *params)
  end
end