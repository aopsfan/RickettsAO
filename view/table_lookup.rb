# table_lookup.rb
# 
# View which prints tabled data into the command line

class TableLookup
  
  # Properties user_quit, tables, header
  attr_reader :user_quit
  attr_accessor :tables, :header
  
  # Initializer
  # Assigns header, sets tables to an empty hash, and sets
  #   user_quit to false.
  def initialize(header)
    @tables = {}
    @header = header
    @user_quit = false
  end
  
  # Bracket notation to set a value for a key in the tables hash
  def []=(lookup, table)
    @tables[lookup] = table
  end
  
  # Bracket notation to retrieve a value from a key in the
  #   tables hash
  def [](lookup)
    @tables[lookup]
  end
  
  # Prompts the user to enter a lookup key using the prompt
  #   parameter, then formats and prints the universal header,
  #   followed by the entire table queried.
  # If the user enters "quit" instead of a valid query, the
  #   method exits and user_quit is set to true.
  def load_table(prompt)
    cli = HighLine.new
    lookup = cli.ask prompt
    table = @tables[lookup]
    
    if lookup == "quit"
      @user_quit = true
      return
    end
    
    puts header.join("\t\t")
    
    table.each do |row|
      puts row.map{|p| "%.6f" % p}.join("\t")
    end
  end
end