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
require_relative 'controller/configuration_controller'

require_relative 'view/wavefunction_graph'
require_relative 'view/table_lookup'

require_relative 'CLI/console'
require_relative 'CLI/interpreter'
require_relative 'CLI/parsers/boolean_parser'
require_relative 'CLI/parsers/key_value_parser'
require_relative 'CLI/parsers/number_parser'
require_relative 'CLI/parsers/single_format_parser'
require_relative 'CLI/parsers/string_parser'
require_relative 'CLI/parsers/symbol_parser'

# DEFAULT NORMALIZATION SETUP
#
GaussianPrimitive.normalize = true
BasisFunction.normalize = false
AtomicOrbital.normalize = true

# INTERPRETER/CONSOLE SETUP
#
interpreter = Interpreter.new
interpreter.delegate = ConfigurationController.new(Console.instance)
Console.instance.interpreter = interpreter
