class BasisSetController
  
  # Properties atomic_orbitals, partial_controllers, table_lookup,
  #   basis_set
  attr_reader :atomic_orbitals, :partial_controllers, :table_lookup, :graph
  attr_accessor :basis_set
  
  # Initializer
  # Assigns the basis sets and quickly generates the child
  #   partial_controllers array.
  # Organizes all of the orbitals from partial_controllers,
  #   condensing single-zeta orbitals with the same n-value
  #   and angular momentum into one multi-zeta orbital.
  def initialize(basis_set)
    @graph = WavefunctionGraph.new
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
  end
  
  # Load table using table_lookup
  def load_table(orbital_name)
    @table_lookup.load_table(orbital_name)
  end
  
  # String representation of the controller, printing the element
  #   and contraction, as well as the string representation of each
  #   atomic orbital.
  def to_s
    "{\n  basis set: #{@basis_set}\n  controller: #{@basis_set.contraction}:\n" +
    @atomic_orbitals.map{|orbital| "\t" + orbital.to_s}.join(",\n") + "\n}"
  end
  
  def configure(x0, xn, dx, options)
    @graph.configure(x0, xn, dx, options)
  end
  
  def plot(options)
    n_values = options[:n] ? [options[:n]] : energy_levels
    characters = options[:char] ? [options[:char]] : @basis_set.characters
    new_plots = []
    
    @atomic_orbitals.each do |orbital|
      next if !characters.include?(orbital.ang_moment.character) || !n_values.include?(orbital.n)
      title = "#{@basis_set.name}: #{@basis_set.element} - #{orbital.name}"
      new_plots << @graph.plot(orbital.wavefunction, title)
    end
    
    new_plots
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
    raise ArgumentError
  end
end