# table_lookup.rb
# 
# View which prints tabled data into the command line

class TableLookup
  
  # Properties tables, header
  attr_accessor :tables, :header
  
  # Initializer
  # Assigns header, sets tables to an empty hash.
  def initialize(header)
    @tables = {}
    @header = header
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
  
  # Formats and prints the universal header, followed by the
  #   entire table queried.
  def load_table(lookup)
    table = @tables[lookup]
    
    puts header.join("\t\t")
    
    table.each do |row|
      puts row.map{|p| "%.6f" % p}.join("\t")
    end
  end
end