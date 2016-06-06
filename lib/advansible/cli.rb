require 'thor'

require_relative 'ui/interface'

# for files in ./cli/commands/*.rb
Dir.glob(File.join(File.dirname(__FILE__), 'cli/commands/*.rb')).each do |file|
  require_relative file
end

require_relative 'cli/main'
