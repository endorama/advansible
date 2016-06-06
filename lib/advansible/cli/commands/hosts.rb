# encoding: UTF-8

require 'command_line_reporter'

module Advansible
  module Cli
    module Commands
      # List availabe hosts commands
      class Hosts < Thor
        include CommandLineReporter

        default_task :list

        desc 'list', 'Return hosts list'
        option :sort, default: 'name'
        def list
          Advansible.logger.info "Loading inventory from #{options[:inventory]}" if options[:verbose]
          inventory = Advansible::Inventory.new(options[:inventory])
          ui = UI::Interface.new
          case options[:sort]
          when 'name'
            ui.warn 'Sorting by fqdn'
            sort_field = :fqdn
          when 'env'
            ui.warn 'Sorting by environment'
            sort_field = :environment
          else
            if inventory.hosts.first.respond_to?(options[:sort].to_sym)
              sort_field = options[:sort].to_sym 
            else
              ui.warn 'Sort key undefined'
              sort_field = :fqdn
            end
          end

          list = inventory.hosts.sort_by { |h| h.send(sort_field) }

          table do
            row(header: true) do
              column 'Name', width: 40
              column 'Location'
              column 'Purpose'
              column 'Project'
              column 'Env'
            end
            list.each do |l|
              row do
                column l.fqdn
                column l.location
                column l.purpose
                column l.project
                column l.environment
              end
            end
          end
        end
      end
    end
  end
end
