require 'advansible/config'
require 'advansible/exceptions'
require 'advansible/logger'
require 'advansible/version'

require 'advansible/inventory'

module Advansible
  def self.debug?
    !!@debug
  end

  def self.debug!
    @debug = true
  end

  def self.undebug!
    @debug = false
  end

  def self.configs
    Config.data
  end

  def self.configs=(data)
    Config.data = data
  end

  def self.config(key, data)
    Config.data = { key => data }
  end
end
