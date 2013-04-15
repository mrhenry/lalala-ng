module Lalala::ExtBetterErrors::Middleware
  extend ActiveSupport::Concern

  included do
    remove_method :allow_ip?
    alias_method :allow_ip?, :_ng_allow_ip?
  end

private

  def _ng_allow_ip?(env)
    true
  end

end
