module Lalala::ExtBetterErrors
  extend ActiveSupport::Autoload

  autoload :Middleware

  def self.patch!
    BetterErrors::Middleware.send :include, Lalala::ExtBetterErrors::Middleware
  end

end
