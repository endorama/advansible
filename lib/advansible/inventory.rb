# encoding: UTF-8

require_relative 'inventory_file'
require_relative 'host'
require_relative 'host_group'

module Advansible
  class Inventory
    extend Forwardable

    attr_reader :domain, :hosts, :groups

    def initialize (inventory_path = nil)
      inventory_file = InventoryFile.new inventory_path
      inventory_file.lint

      @db = inventory_file.content

      @domain = @db['domain'] 
      
      @hosts = @db['hosts'].map { |h| Host.new(h, @domain) }

      # retrieve all groups from hosts list
      @groups = @hosts.inject([]) { |a, e| a << e.groupnames }.flatten.uniq.sort.map { |g| HostGroup.new(g) }
      @hosts.each do |host|
        host.groupnames.each do |groupname|
          group(groupname).add_hostname host
        end
      end

      @inventory_path = inventory_path
    end

    def find(hostname)
      host = @hosts.find { |h| h.fqdn == hostname }
      host = @hosts.find { |h| h.fqdn == "#{hostname}.#{@domain}" } unless host
      host
    end

    def group(name)
      @groups.find { |g| g.name == name }
    end

    def path
      @inventory_path
    end

    def to_json(*a)
      hash = {}
      @groups.each do |group|
        hash[group.name] = group
      end
      hash.to_json(*a)
    end

    # List all querable fields
    def list_querable
      @db['hosts'].first.instance_variables.map { |e| e.to_s.delete('@') }
    end

    # Execute a query on the database
    def query(key, value)
      # puts "==> Searching db for host with #{key}: #{value}" if $debug
      
      # JSON requires an hash
      data = { hosts: [] }
      # for each host
      @db['hosts'].each do |host|
        # skip if do not have required key
        next unless host.respond_to?(key)
        # skip if required key value is not the one requested
        next unless host.send(key) == value
        # add to returned data
        data[:hosts] << host
      end

      # puts "No data found for query '#{key}:#{value}'" if data[:hosts].empty? && $debug

      data
    end

    private

  end
end