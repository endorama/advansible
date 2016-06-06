
module Advansible
  module Exceptions
    class BaseException < StandardError
      def initialize(msg = nil)
        @message = msg
      end

      def message
        @message.to_s
      end
    end
  end
end
