require 'colored'

module Advansible
  module UI
    module Formatters
      class Colored
        def color?
          true
        end
        
        def format(type, message)
          case type
          when :detail
            message = message.cyan  
          when :info
          when :error
            message = message.red.bold
          when :success
            message = message.green.bold
          when :warn
            message = message.yellow
          end
          message
        end
      end
    end
  end
end