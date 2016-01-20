class ConsoleLibrary
  def close(c, args)
    c.close
  end

  def dump(c, args)
    c.dump
  end

  def load(c, args)
    full_name = "#{args[:name]}_#{args[:element]}"
    raw_basis_set = File.open("resources/basis_sets/#{full_name}.yaml").read
    components = YAML.load(raw_basis_set)
    
    c.attach(:basis_set, BasisSet.new(args[:name], components))
  end

  def pretty_print(c, args)
    basis_set = c.basis_set
    c.log("Basis set #{basis_set.name}: #{basis_set.contraction}.")
    c.log(c.basis_set.gaussian94_format)
  end

  def normalize(c, args)
    normalize_primitives = args[:primitives] == nil ? true : args[:primitives]
    normalize_functions = args[:functions] == nil ? false : args[:functions]
    normalize_orbitals = args[:orbitals] == nil ? false : args[:orbitals]
    
    GaussianPrimitive.normalize = normalize_primitives
    BasisFunction.normalize = normalize_functions
    AtomicOrbital.normalize = normalize_orbitals
    
    c.log("Updated normalization settings.")
  end

  def configure(c, args)
    basis_set = c.basis_set
    c.attach(:basis_set_controller, BasisSetController.new(basis_set))
  end

  def write_graphs(c, args)
    basis_set = c.basis_set
    controller = c.basis_set_controller
    controller.write_graphs(basis_set.name, "resources/graphs")

    c.log("Output graphs to resources/graphs")
  end

  def load_table(c, args)
    controller = c.basis_set_controller
    controller.load_table(args[:orbital])
  end
  
  def method_missing(method_name, *args)
    puts "No command called #{method_name}."
  end
end