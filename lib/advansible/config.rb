
module Advansible
  # Config module is a configuration object shared by all application
  # The configuration data are frozen to prevent modification, the only accepted
  # way to change them is via the data=() function
  module Config
    # HOST = { name: 'localhost', port: 3000 }.freeze
    # WEB  = { login_url:  "#{HOST[:name]}:#{HOST[:port]}/login" }.freeze
    
    # default data
    @data = {
      cwd: Dir.pwd
    }.freeze

    def self.data
      @data
    end

    def self.data=(data)
      # asd = @data.merge(data)
      # puts 'asd', asd.inspect
      # @data = asd

      # asd = @data.merge(data)
      # puts 'asd', asd.inspect
      # @data = asd
      @data = @data.merge(data)
    end
  end
end
