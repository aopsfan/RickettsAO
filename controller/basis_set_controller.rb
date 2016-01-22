class BasisSetController
  
  # Properties atomic_orbitals, partial_controllers, table_lookup,
  #   basis_set
  attr_reader :atomic_orbitals, :partial_controllers, :table_lookup
  attr_accessor :basis_set
  
  # Initializer
  # Assigns the basis sets and quickly generates the child
  #   partial_controllers array.
  # Organizes all of the orbitals from partial_controllers,
  #   condensing single-zeta orbitals with the same n-value
  #   and angular momentum into one multi-zeta orbital.
  def initialize(basis_set)
    @basis_set = basis_set
    @partial_controllers = basis_set.partials.map{|partial| BasisSetPartialController.new(partial)}
    
    all_orbitals = @partial_controllers.reduce([]) do |memo, partial_controllers|
      memo + partial_controllers.atomic_orbitals
    end
    
    grouped_orbitals = all_orbitals.group_by do |orbital|
      {n: orbital.n, ang_moment: orbital.ang_moment}
    end
    
    @atomic_orbitals = grouped_orbitals.map do |key, old_orbitals|
      new_orbital = AtomicOrbital.new(key[:n], key[:ang_moment])
      old_orbitals.each do |old_orbital|
        new_orbital.add_basis_function(old_orbital.basis_functions.first)
      end
      
      new_orbital
    end
    
    @table_lookup = TableLookup.new(["r", "wavefunction"])
    @atomic_orbitals.each {|orbital| @table_lookup[orbital.name] = table_for(orbital)}
  end
  
  # Load table using table_lookup
  def load_table(orbital_name)
    @table_lookup.load_table(orbital_name)
  end
  
  # Write graphs using WavefunctionPlot.
  # For each energy level, a graph is generated and written to
  #   a file.
  def write_graphs(basis_set_name, filepath)
    energy_levels.each do |n, orbitals|
      Gnuplot.open do |gp|
        Gnuplot::Plot.new(gp) do |plot|
          plot.terminal "png"
          plot.output File.expand_path("../../#{filepath}/#{basis_set.element}_#{n}_#{basis_set_name}.png", __FILE__)
          
          plot.title "#{basis_set.element} - n=#{n} - #{basis_set_name}"
          plot.xlabel "r"
          plot.ylabel "wf"
          
          orbitals.each do |o|
            x = @table_lookup[o.name].map{|k, v| k}
            y = @table_lookup[o.name].map{|k, v| v}
            plot.data << Gnuplot::DataSet.new([x,y]) do |ds|
              ds.with = "points"
              ds.title = o.name
            end
          end
        end
      end
    end
  end
  
  # String representation of the controller, printing the element
  #   and contraction, as well as the string representation of each
  #   atomic orbital.
  def to_s
    "basis set controller: #{@partial_controllers.length} partials, #{@basis_set.element} #{@basis_set.contraction}:\n" +
    @atomic_orbitals.map{|orbital| "\t" + orbital.to_s}.join(",\n")
  end
  
  private
  
  # A hash pointing principal quantum numbers to arrays of
  #   atomic orbitals
  def energy_levels
    @atomic_orbitals.group_by {|orbital| orbital.n}
  end
  
  # Full table (array of arrays) for the provided atomic orbital.
  # First column is r, second column is the wavefunction's output.
  def table_for(atomic_orbital)
    positions.map{|p| [p.r, atomic_orbital.wavefunction.call(p)]}
  end
  
  # All points in Cartesian space used
  # Returns Position instances with x-values ranging from 0 to
  #   3 in increments of 0.01. y and z will be 0.
  def positions
    steps = 0.step(3, 0.01)
    steps.map{|s| Position.new(s)}
  end
end