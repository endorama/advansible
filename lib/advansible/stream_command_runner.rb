require 'pty'

module Advansible
  # Runa command and print it's streamed output
  # 
  class StreamCommandRunner
    def initialize(command)
      @command = command
      @arguments = []
      @options = {}
      @flags = []
      @root = nil
    end

    def self.command(command)
      StreamCommandRunner.new(command)
    end

    def argument(argument)
      @arguments << argument
      self
    end

    def arguments(arguments)
      @arguments.concat arguments 
      self
    end

    def from(folder)
      @root = folder
      self
    end

    def option(name, value)
      value = value.join(',') if value.is_a? Array
      @options[name] = value
      self
    end

    def flag(name)
      @flags << name
      self
    end

    def to_s
      cmd = @command.to_s
      cmd = "cd #{@root} && #{cmd}" if @root
      @arguments.each { |a| cmd = "#{cmd} #{a}" }
      @options.each { |k, v| cmd = "#{cmd} #{k}=#{v}" }
      @flags.each { |v| cmd = "#{cmd} #{v}" }
      cmd
    end

    def run
      PTY.spawn(to_s) do |stdout, _, _| # stdout, stdin, pid
        begin
          stdout.each { |line| print line }
        rescue Errno::EIO
          puts 'IO Error; probably the child process stopped sending output'
        end
      end
    rescue PTY::ChildExited
      puts 'The child process exited!'
    end
  end
end
