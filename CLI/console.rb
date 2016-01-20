require 'singleton'

class Console
  include Singleton
  
  attr_accessor :interpreter
  attr_reader :client, :memory
  
  def initialize
    @client = HighLine.new
    @is_open = true
    @memory = {}
  end
  
  def attach(key, value)
    @memory[key] = value
    log("#{key} -> #{value}")
  end
  
  def dump
    @memory = nil
    log("All memory cleared.")
  end
  
  def log(message)
    puts message
  end
  
  def open
    log("Opened console.")
    while @is_open
      get_line
    end
  end
  
  def close
    @is_open = false
    log("Closed console.")
  end
  
  private
  
  def get_line
    line = @client.ask "RickettsAO: console -> "
    @interpreter.execute(self, line)
  end
end