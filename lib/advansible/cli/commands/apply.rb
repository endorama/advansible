# encoding: UTF-8

require_relative '../../stream_command_runner'

module Advansible
  module Cli
    module Commands
      # Ansible commands
      class Apply < Thor
        default_task :apply

        desc 'apply <playbook> <host>', 'Run <playbook> on <host>'
        def apply(playbook, hostname)
          Advansible.logger.info "Loading inventory from #{options[:inventory]}" if options[:verbose]
          inventory = Advansible::Inventory.new(options[:inventory])
          host = inventory.find hostname
          ui = UI::Interface.new
          if host
            ui.detail "Run for #{host.fqdn}"
            playbook = File.join(Advansible.configs[:cwd], playbook)
            ui.info "Loading '#{playbook}'", nest: 1
            # unless File.exist? playbook
            #   ui.error 'Playbook does not exists', nest: 1 
            #   Sysexits.exit(:dataerr)  
            # end
            cmd = StreamCommandRunner.command('ansible-playbook')
                                     .argument(playbook)
                                     .option('--limit', host.fqdn)
            cmd.flag('-vvv') if options[:verbose]
            # cmd.run
            puts cmd
          else
            ui.error 'Cannot find host'
            Sysexits.exit(:dataerr)
          end
        end
      end
    end
  end
end
