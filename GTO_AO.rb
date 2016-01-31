# GTO_AO.rb
#
# Run this file FROM THE ROOT DIRECTORY for the full GTO CLI.

# Load all relevant files and setup
require 'yaml'
require 'highline'
require 'gnuplot'

require_relative 'sources'

# Start the CLI
Console.instance.open