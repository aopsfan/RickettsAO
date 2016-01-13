class TableLookup
  attr_reader :user_quit
  attr_accessor :tables, :header
  
  def initialize(header)
    @tables = {}
    @header = header
    @user_quit = false
  end
  
  def []=(lookup, table)
    @tables[lookup] = table
  end
  
  def [](lookup)
    @tables[lookup]
  end
  
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