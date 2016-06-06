# encoding: UTF-8

module Advansible
  class HostGroup
    attr_reader :name, :hosts, :vars

    def initialize(groupname)
      @name = groupname
      @hostnames = []
      @vars = compute_vars
    end

    def add_hostname(host)
      @hostnames << (Advansible.configs[:nicenames] ? host.fqdn : host.cname)
    end

    def to_json(*a)
      hash = {
        hosts: @hostnames,
        vars: @vars
      }
      hash.to_json(*a)
    end

    def vars_file
      File.join(Advansible.configs[:cwd], 'vars', 'groups', "#{@name}.yml")
    end

    private

    def compute_vars
      return {} unless File.exist? vars_file
      {}.merge(YAML.load(File.read(vars_file)))
    end
  end
end