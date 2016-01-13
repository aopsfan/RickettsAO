require_relative 'wavefunctions/gaussian_primitive'
require_relative 'wavefunctions/basis_function'
require_relative 'wavefunctions/atomic_orbital'

require_relative 'model/ang_moment'
require_relative 'model/basis_set_row'
require_relative 'model/basis_set_partial'
require_relative 'model/basis_set'
require_relative 'model/position'

require_relative 'controller/basis_set_partial_controller'
require_relative 'controller/basis_set_controller'

require_relative 'view/wavefunction_plot'
require_relative 'view/table_lookup'

require 'gruff'
require 'yaml'
require 'highline'

GaussianPrimitive.normalize = false
BasisFunction.normalize = true
AtomicOrbital.normalize = true

cli = HighLine.new

basis_set_name = cli.ask "basis set name: "
element_name   = cli.ask "element name: "
full_name      = "#{basis_set_name}_#{element_name}"

raw_basis_set = File.open("resources/basis_sets/#{full_name}.yaml").read
components = YAML.load(raw_basis_set)
basis_set = BasisSet.new(components)

print "\n\n\n"
puts "LOADED BASIS SET:"
puts "      element: #{basis_set.element}"
puts "  contraction: #{basis_set.contraction}"

print "\n\n\n"
puts "GAUSSIAN94 FORMAT:"
puts basis_set.gaussian94_format

controller = BasisSetController.new(basis_set)

print "\n\n\n"
puts "GENERATED BASIS SET CONTROLLER:"
puts controller.to_s

print "\n\n\n"
puts "WRITING GRAPHS"

controller.write_graphs(basis_set_name, "resources/graphs")

print "\n\n\n"
puts "STARTING TABLE LOOKUP"

while !controller.user_quit?
  controller.load_table
  print "\n"
end
