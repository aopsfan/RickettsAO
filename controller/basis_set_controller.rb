class BasisSetController
  attr_reader :atomic_orbitals, :partial_controllers, :table_lookup
  attr_accessor :basis_set
  
  # atomic_orbitals
  # 
  # All of the orbitals from the shell controllers,
  # condensing single-zeta orbitals with the same n-value
  # and ang-moment into one n-zeta orbital.
  # 
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
  
  def load_table
    @table_lookup.load_table("enter orbital name: ")
  end
  
  def write_graphs(basis_set_name, filepath)
    energy_levels.each do |n, orbitals|
      g = WavefunctionPlot.plot("#{basis_set.element} - n=#{n} - #{basis_set_name}")
      
      orbitals.each do |o|
        g.data o.name, @table_lookup[o.name].map{|key, value| value}
      end
      
      g.write("#{filepath}/#{basis_set.element}_#{n}_#{basis_set_name}.png")
    end
  end
  
  def user_quit?
    @table_lookup.user_quit
  end
  
  def to_s
    "basis set controller: #{@partial_controllers.length} partials, #{@basis_set.element} #{@basis_set.contraction}:\n" +
    @atomic_orbitals.map{|orbital| "\t" + orbital.to_s}.join(",\n")
  end
  
  private
  
  def energy_levels
    @atomic_orbitals.group_by {|orbital| orbital.n}
  end
  
  def table_for(atomic_orbital)
    positions.map{|p| [p.r, atomic_orbital.wavefunction.call(p)]}
  end
  
  def positions
    steps = 0.step(3, 0.1)
    steps.map{|s| Position.new(s)}
  end
end