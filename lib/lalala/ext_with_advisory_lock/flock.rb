module Lalala::ExtWithAdvisoryLock::Flock
  extend ActiveSupport::Concern

  included do
    remove_method :filename
    alias_method :filename, :_ng_filename
  end

  def _ng_filename
    @filename ||= begin
      safe = @lock_name.gsub(/[^a-z0-9]/i, '')
      fn = "lock-#{safe}-#{@lock_name.to_s.hash}"

      dir = File.join(Rails.application.paths['tmp'].first, 'locks')
      FileUtils.mkdir_p(dir)

      File.join(dir, fn)
    end
  end

end
