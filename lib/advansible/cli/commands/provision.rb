# encoding: UTF-8

require_relative '../../stream_command_runner'

module Advansible
  module Cli
    module Commands
      class Provision < Thor
        default_task :provision

        desc 'provision <host>', 'Provision <host> based on its project and stage set in inventory'
        def provision(hostname)
          Advansible.logger.info "Loading inventory from #{options[:inventory]}" if options[:verbose]
          Advansible.logger.info 'Ansible will be run with verbose output' if options[:verbose]
          inventory = Advansible::Inventory.new(options[:inventory])
          host = inventory.find hostname
          ui = UI::Interface.new
          if host
            ui.detail "Provision for #{host.fqdn}\n"
            playbook = File.join(Advansible.configs[:cwd], 
                                 'playbooks', 'projects', host.project,
                                 "#{host.purpose}_#{host.environment}.yml")
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
