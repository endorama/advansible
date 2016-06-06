require 'advansible/ui/formatters/colored'

module Advansible
  module UI
    # This class is heavily based on the awesome work for the Vagrant command line
    # interface. You can find it here: 
    #   https://github.com/mitchellh/vagrant/blob/30d9e243bb99788ead83d1f316797563f184819f/lib/vagrant/ui.rb
    class Interface
      extend Forwardable

      # Opts can be used to set some options. These options are implementation
      # specific. See the implementation for more docs.
      attr_accessor :opts

      # Formatter to render output. Default to Formatters::Colored
      attr_accessor :formatter

      # @return [IO] UI input. Defaults to `$stdin`.
      attr_accessor :stdin

      # @return [IO] UI output. Defaults to `$stdout`.
      attr_accessor :stdout

      # @return [IO] UI error output. Defaults to `$stderr`.
      attr_accessor :stderr

      def initialize
        @logger = Advansible.logger
        @formatter = UI::Formatters::Colored.new

        @stderr = $stderr
        @stdin = $stdin
        @stdout = $stdout
      end

      # Delegate format to @formatter
      def_delegator :formatter, :format
      def_delegator :formatter, :color?

      # Use some light meta-programming to create the various methods to
      # output text to the UI. These all delegate the real functionality
      # to `say`.
      [:detail, :info, :warn, :error, :output, :success].each do |method|
        class_eval <<-CODE
          def #{method}(message, *args)
            # @logger.send('info', message)
            say(#{method.inspect}, message, *args)
          end
        CODE
      end

      def ask
        # Thank you Vagrant :)
        # super(message)

        # # We can't ask questions when the output isn't a TTY.
        # raise Errors::UIExpectsTTY if !@stdin.tty? && !Vagrant::Util::Platform.windows?

        # # Setup the options so that the new line is suppressed
        # opts ||= {}
        # opts[:echo]     = true  if !opts.key?(:echo)
        # opts[:new_line] = false if !opts.key?(:new_line)
        # opts[:prefix]   = false if !opts.key?(:prefix)

        # # Output the data
        # say(:info, message, opts)

        # input = nil
        # if opts[:echo] || !@stdin.respond_to?(:noecho)
        #   input = @stdin.gets
        # else
        #   begin
        #     input = @stdin.noecho(&:gets)

        #     # Output a newline because without echo, the newline isn't
        #     # echoed either.
        #     say(:info, "\n", opts)
        #   rescue Errno::EBADF
        #     # This means that stdin doesn't support echoless input.
        #     say(:info, "\n#{I18n.t("vagrant.stdin_cant_hide_input")}\n ", opts)

        #     # Ask again, with echo enabled
        #     input = ask(message, opts.merge(echo: true))
        #   end
        # end

        # # Get the results and chomp off the newline. We do a logical OR
        # # here because `gets` can return a nil, for example in the case
        # # that ctrl-D is pressed on the input.
        # (input || "").chomp
      end

      def choose(choices = [])
      end

      def clear_line
        # See: http://en.wikipedia.org/wiki/ANSI_escape_code
        reset = "\r"
        log reset, new_line: false
      end

      def log(message, *args)
        say(nil, message, *args)
      end

      # This is used to output progress reports to the UI.
      # Send this method progress/total and it will output it
      # to the UI. Send `clear_line` to clear the line to show
      # a continuous progress meter.
      def report_progress(progress, total = nil, show_parts: true, nest: 0)
        if total && total > 0
          percent = (progress.to_f / total.to_f) * 100
          line = "Progress: #{percent.to_i}%"
          line << " (#{progress} / #{total})" if show_parts
        else
          line = "Progress: #{progress}"
        end

        info(line, new_line: false, nest: nest)
      end

      def say(type, message, new_line: true, echo: true, nest: 0)
        line = "#{' ' * nest * 2 }#{format(type, message)}"
        printer = new_line ? :puts : :print

        @stdout.send(printer, line)
      end
    end
  end
end
