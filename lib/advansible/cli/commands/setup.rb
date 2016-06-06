# encoding: UTF-8

require_relative '../../stream_command_runner'

module Advansible
  module Cli
    module Commands
      # Ansible commands
      class Setup < Thor
        default_task :setup

        desc 'setup <host>', 'Setup the specified host'
        def setup(hostname)
          Advansible.logger.info "Loading inventory from #{options[:inventory]}" if options[:verbose]
          inventory = Advansible::Inventory.new(options[:inventory])
          host = inventory.find hostname
          ui = UI::Interface.new
          if host
            ui.detail "Setup for #{host.fqdn}"
            ui.info 'Initializing setup sequence...'
            ui.info "Loading vars from #{host.vars_file}"
            Advansible.logger.debug host.vars.inspect
            # fail 'You should specify ansible_ssh_user to the host var file' unless host.vars.has_key?('ansible_ssh_user')
            ui.info 'Loading "playbooks/init.yml"'
            puts StreamCommandRunner.command('ansible-playbook')
              .from(Advansible.configs[:cwd])
              .argument('playbooks/init.yml')
              .flag('--limit', host.fqdn)
              # .run
            ui.info 'Loading "playbooks/setup.yml"'
            puts StreamCommandRunner.command('ansible-playbook')
              .from(Advansible.configs[:cwd])
              .argument('playbooks/setup.yml')
              .flag('--limit', host.fqdn)
              # .run
            ui.info 'Loading "playbooks/location.yml"'
            puts StreamCommandRunner.command('ansible-playbook')
              .from(Advansible.configs[:cwd])
              .argument('playbooks/location.yml')
              .flag('--limit', host.fqdn)
              # .run
          else
            ui.error 'Cannot find host'
            Sysexits.exit(:dataerr)
          end
        end
      end
    end
  end
end
