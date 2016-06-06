
module Advansible
  module UI
    module Formatters
      class Simple
        def color?
          false
        end
        
        def format(type, message)
          message
        end
      end
    end
  end
end