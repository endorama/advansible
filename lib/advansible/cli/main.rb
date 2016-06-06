require 'thor'
require 'logger'
require 'sysexits'

module Advansible
  module Cli
    # Main CLI definitions
    class Main < Thor
      class_option :verbose, type: :boolean, aliases: '-v'
      class_option :debug, type: :boolean
      class_option :inventory, type: :string, aliases: '-i', default: 'hosts.yml'

      def initialize(*args)
        super # call before everything to have options[] filled

        Advansible.logger.level = ::Logger::INFO if options[:verbose]

        if options[:debug]
          Advansible.logger.level = ::Logger::DEBUG
          Advansible.debug!
          Advansible.logger.info 'Debug mode enabled'
        end
      end

      desc 'apply <playbook> <host>', 'Run <playbook> on <host>'
      subcommand 'apply', Advansible::Cli::Commands::Apply
      
      desc 'hosts', 'List hosts'
      subcommand 'hosts', Advansible::Cli::Commands::Hosts

      desc 'provision <host>', 'Provision <host> based on its project and stage set in inventory'
      subcommand 'provision', Advansible::Cli::Commands::Provision

      desc 'setup <host>', 'Perform setup on HOST'
      subcommand 'setup', Advansible::Cli::Commands::Setup

      desc 'version', 'Print version'
      def version
        ui = UI::Interface.new
        ui.info "Advansible version: #{Advansible::VERSION}"
      end
    end
  end
end
