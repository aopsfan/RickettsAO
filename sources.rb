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

require_relative 'CLI/console'
require_relative 'CLI/interpreter'
require_relative 'CLI/console_library'

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
library = ConsoleLibrary.new
interpreter = Interpreter.new(library)
Console.instance.interpreter = interpreter
