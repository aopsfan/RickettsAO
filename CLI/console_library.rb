class ConsoleLibrary
  def initialize(console)
    @console = console
  end
  
  def close
    @console.close
  end

  def dump
    @basis_set = nil
    @basis_set_controller = nil
    @console.log("Cleared all memory.")
  end

  def attach(name, element)
    full_name = "#{name}_#{element}"
    raw_basis_set = File.open("resources/basis_sets/#{full_name}.yaml").read
    components = YAML.load(raw_basis_set)
    
    @basis_set = BasisSet.new(name, components)
    @console.log(:basis_set, @basis_set)
  end

  def pretty_print
    @console.log("Basis set #{@basis_set.name}: #{@basis_set.contraction}.")
    @console.log(@basis_set.gaussian94_format)
  end

  def normalize(primitives=true, functions=false, orbitals=false)
    GaussianPrimitive.normalize = primitives
    BasisFunction.normalize = functions
    AtomicOrbital.normalize = orbitals
    
    @console.log("Updated normalization settings.")
  end

  def configure
    @basis_set_controller = BasisSetController.new(@basis_set)
    @console.log(:basis_set_controller, @basis_set_controller)
  end

  def write_graphs
    @basis_set_controller.write_graphs(@basis_set.name, "resources/graphs")
    @console.log("Output graphs to resources/graphs")
  end

  def load_table(orbital)
    @basis_set_controller.load_table(orbital)
  end
  
  def method_missing(method_name, *args)
    puts "No command called #{method_name}."
  end
end