class Command
  attr_reader :key
  
  def initialize(key, &block)
    @key = key
    @action = block
  end
  
  def execute(console, args)
    @action.call(console, args)
  end
end
