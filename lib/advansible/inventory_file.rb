require 'yaml'

module Advansible
  class InventoryFile
    attr_reader :content

    # Init a InventoryFile instance
    #
    # @param path A file path where to find the hosts file to load
    #   default: cwd + hosts.yml
    def initialize(path)
      @path = path
      @path = File.join(Advansible.configs[:cwd], 'hosts.yml') unless path
      raise Exceptions::InventoryFile::Missing.new(@path) unless File.exist? @path
      @content = YAML.load(File.read(@path))
      raise Exceptions::InventoryFile::MissingContent unless @content
    end

    # Lint an inventory file, checking for missing top level keys
    # 
    # @raise Exceptions::InventoryFile::MissingDomain
    # @raise Exceptions::InventoryFile::MissingHosts
    def lint
      raise Exceptions::InventoryFile::MissingDomain unless content.key? 'domain'
      raise Exceptions::InventoryFile::MissingHosts unless content.key? 'hosts'
    end
  end
end
