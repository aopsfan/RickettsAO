class SingleFormatParser
  def initialize
    @parsers = [BooleanParser.new, NumberParser.new, KeyValueParser.new(self), StringParser.new, SymbolParser.new(self)]
  end
  
  def arg_with(format)
    @parsers.reduce(nil) {|memo, parser| memo || parser.arg_with(format)}
  end
  
  def options_with(format)
    @parsers.reduce({}) {|memo, parser| memo.merge(parser.options_with(format))}
  end
end