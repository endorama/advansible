
module Advansible
  module Exceptions
    module InventoryFile
      # Exception to raise when an InventoryFile is not found at the specified path
      #
      # @see  InventoryFile.initialize
      class Missing < Advansible::Exceptions::BaseException
        def initialize(path)
          super "Inventory file does not exist: #{path}"
        end
      end

      # Exception to raise when YAML.load on an InventoryFile returns false
      #
      # @see  InventoryFile.initialize
      class MissingContent < Advansible::Exceptions::BaseException
        def initialize
          super 'Inventory file is empty'
        end
      end

      # Exception to raise when an InventoryFile has no :domain top level key
      #
      # @see  InventoryFile.lint
      class MissingDomain < Advansible::Exceptions::BaseException
        def initialize
          super 'Inventory file is missing :domain key'
        end
      end

      # Exception to raise when an InventoryFile has no :hosts top level key
      #
      # @see  InventoryFile.lint
      class MissingHosts < Advansible::Exceptions::BaseException
        def initialize
          super 'Inventory file is missing :hosts key'
        end
      end
    end
  end
end
