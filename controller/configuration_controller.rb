class ConfigurationController
  def initialize(console)
    @console = console
    @basis_set_controllers = []
    @graph = WavefunctionGraph.new
  end
  
  def close(options)
    @console.close
  end

  def dump(options)
    @graph.dump(options)
    @basis_set_controllers = []
    @console.log("Cleared all memory.")
  end

  def attach(name, element, options)
    full_name = "#{name}_#{element}"
    raw_basis_set = File.open("resources/basis_sets/#{full_name}.yaml").read
    components = YAML.load(raw_basis_set)
    
    @basis_set_controllers << BasisSetController.new(BasisSet.new(name, components))
    @console.log_state(:basis_set_controllers, "[" + @basis_set_controllers.map{|c| c.to_s}.join(",\n") + "]")
  end

  def normalize(options)
    GaussianPrimitive.normalize = options[:primitives]
    BasisFunction.normalize = options[:functions]
    AtomicOrbital.normalize = options[:orbitals]
    
    @console.log("updated normalization settings.")
  end

  def configure(x0, xn, dx, options)
    @graph.configure(x0, xn, dx, options)
    @basis_set_controllers.each {|c| c.configure(x0, xn, dx, options)}
    
    @console.log_state(:configuration, "wavefunctions will be evaluated from r = #{x0} to r = #{xn} in increments of #{dx}.")
  end
  
  def plot(options)
    @basis_set_controllers.each do |c|
      @graph.add(c.plot(options))
    end
    
    @console.log_state(:graph, @graph)
  end

  def write_plots(filename, options)
    @graph.write_plots("../../resources/graphs/#{filename}", options)
    @console.log("Output graph to resources/graphs")
  end

  def load_table(orbital)
    @basis_set_controller.load_table(orbital)
  end
  
  def method_missing(method_name, *args)
    puts "No command called #{method_name}."
  end
end