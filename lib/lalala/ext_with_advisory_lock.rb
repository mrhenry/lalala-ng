module Lalala::ExtWithAdvisoryLock
  extend ActiveSupport::Autoload

  autoload :Flock

  def self.patch!
    require 'with_advisory_lock/flock'
    WithAdvisoryLock::Flock.send :include, Lalala::ExtWithAdvisoryLock::Flock
  end

end
