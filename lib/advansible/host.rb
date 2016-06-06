module Advansible
  class Host
    attr_reader :city, :cname, :country, :environment, :fqdn, :hostname, :ip, 
                :location, :number, :project, :purpose

    def initialize(data, domain)
      @location = data[ 'location']
      @country = data['location'].split('.')[1]
      @city = data['location'].split('.')[0]

      @hostname = data['hostname']

      @project = data.key?('project') ? data['project'] : 'none'

      @purpose = data['purpose']
      @number = data['number'].to_s.rjust(2, '0')
      @environment = data['environment']

      @fqdn = compute_fqdn(domain)
      @cname = compute_cname(domain)
      
      @ip = data['ip'] ? data['ip'] : retrieve_ip
    end

    def groupnames
      [location_groups, project_group].flatten
    end

    def location_infos
      output = <<EOS
Location for #{@fqdn}
city:    #{@city}
country: #{@country}
cname:   #{@cname}
ip:      #{@ip}
EOS
      output
    end

    def to_json(*a)
      hash = {}
      instance_variables.sort.each { |var| hash[var.to_s.delete('@')] = instance_variable_get(var) }
      hash.to_json(*a)
    end

    def vars
      return {} unless File.exist? vars_file
      {}.merge(YAML.load(File.read(vars_file)))
    end

    def vars_file
      File.join(Advansible.configs[:cwd], 'vars', 'hosts', "#{@hostname}.yml")
    end

    private

    def project_group
      [@project, @purpose, @environment].join('_')
    end

    def location_groups
      [@country, @location]
    end

    def compute_fqdn(domain)
      "#{@hostname}.#{domain}"
    end

    def compute_cname(domain)
      "#{@purpose}#{@number}.#{@environment}.#{@city}.#{@country}.#{domain}"
    end

    def retrieve_ip
      ip = `dig +short #{@fqdn}`.strip
      return nil if ip.empty?
      ip
    end
  end
end
