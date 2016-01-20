# sources.rb
# 
# Requires all files and gems needed, sets up basis functions

require_relative 'basis_functions/gaussian_primitive'
require_relative 'basis_functions/basis_function'
require_relative 'basis_functions/atomic_orbital'

require_relative 'model/ang_moment'
require_relative 'model/basis_set_row'
require_relative 'model/basis_set_partial'
require_relative 'model/basis_set'
require_relative 'model/position'

require_relative 'controller/basis_set_partial_controller'
require_relative 'controller/basis_set_controller'

require_relative 'view/wavefunction_plot'
require_relative 'view/table_lookup'

require_relative 'CLI/command'
require_relative 'CLI/console'
require_relative 'CLI/interpreter'

require 'gruff'
require 'yaml'
require 'highline'

# DEFAULT NORMALIZATION SETUP
#
GaussianPrimitive.normalize = true
BasisFunction.normalize = false
AtomicOrbital.normalize = true

# INTERPRETER/CONSOLE SETUP
#
interpreter = Interpreter.new
Console.instance.interpreter = interpreter

interpreter.add_command(:quit) {|c, args| c.close}

interpreter.add_command(:dump) {|c, args| c.dump}

interpreter.add_command(:load) do |c, args|
  full_name = "#{args[:name]}_#{args[:element]}"
  raw_basis_set = File.open("resources/basis_sets/#{full_name}.yaml").read
  components = YAML.load(raw_basis_set)
  
  c.attach(:basis_set, BasisSet.new(args[:name], components))
end

interpreter.add_command(:pretty_print) do |c, args|
  basis_set = c.memory[:basis_set]
  c.log("Basis set #{basis_set.name}: #{basis_set.contraction}.")
  c.log(c.memory[:basis_set].gaussian94_format)
end

interpreter.add_command(:normalize) do |c, args|
  normalize_primitives = args[:primitives] == nil ? true : args[:primitives]
  normalize_functions = args[:functions] == nil ? false : args[:functions]
  normalize_orbitals = args[:orbitals] == nil ? false : args[:orbitals]
  
  GaussianPrimitive.normalize = normalize_primitives
  BasisFunction.normalize = normalize_functions
  AtomicOrbital.normalize = normalize_orbitals
  
  c.log("Updated normalization settings.")
end

interpreter.add_command(:configure) do |c, args|
  basis_set = c.memory[:basis_set]
  c.attach(:basis_set_controller, BasisSetController.new(basis_set))
end

interpreter.add_command(:write_graphs) do |c, args|
  basis_set = c.memory[:basis_set]
  controller = c.memory[:basis_set_controller]
  controller.write_graphs(basis_set.name, "resources/graphs")
  
  c.log("Output graphs to resources/graphs")
end

interpreter.add_command(:load_table) do |c, args|
  controller = c.memory[:basis_set_controller]
  controller.load_table(args[:orbital])
end