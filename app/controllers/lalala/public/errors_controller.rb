class Lalala::Public::ErrorsController < ApplicationController

  helper_method :current_exception
  before_filter :capture_current_exception

  # 404 - Not Found
  def not_found
    render layout: false, status: 404
  end

  # 422 - Unprocessable Entity
  def unprocessable_entity
    render layout: false, status: 422
  end

  # 500 - Internal Server Error
  def internal_server_error
    render layout: false, status: 500
  end

private

  def current_exception
    @current_exception ||= env["action_dispatch.exception"]
  end

  def capture_current_exception
    if defined?(::Raven) && ENV['SENTRY_DSN']
      Raven.capture_exception(current_exception)
    end
  end

end
