require 'logger'

module Advansible
  # class Logger
  #   def initialize(logfile = $stdout)
  #     @instance = ::Logger.new(logfile)
  #     @instance.progname = 'advansible'
  #     # :nocov:
  #     @instance.formatter = proc do |severity, datetime, progname, msg|
  #       "#{severity} [#{datetime}]: #{msg}\n"
  #     end
  #     # :nocov:
  #     @instance
  #   end
  # end
  # def self.logger
  #   @logger ||= Logger.new($stdout)
  # end

  class << self
    def logger
      return @logger if @logger
      @logger = Logger.new $stdout
      @logger.level = Logger::WARN
      @logger.progname = 'advansible'
      # :nocov:
      @logger.formatter = proc do |severity, datetime, progname, msg|
        "#{severity} [#{datetime}]: #{msg}\n"
      end
      # :nocov:
      @logger
    end
  end
end