class SpecialLog
  LogFile = Rails.root.join('log', 'special.log')
  class << self
    cattr_accessor :logger
    delegate :debug, :info, :warn, :error, :fatal, :to => :logger
  end
end
