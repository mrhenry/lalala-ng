class Lalala::ExtRack::I18nNegotiator

  include ActionDispatch::Routing::Redirection

  def initialize(app, adapter)
    @app     = app
    @adapter = adapter
  end

  def call(env)
    dup._call(env)
  end

protected

  def _call(env)
    @env = env

    _locale        = I18n.locale
    _locale_source = I18n.locale_source

    if @adapter.ignored?(env)
      I18n.locale = locale_for_ignored.to_sym
      @env['rack.locale'] = I18n.locale
      status, headers, body =  @app.call(env)
      headers['Content-Language'] = I18n.locale.to_s
      return [status, headers, body]
    end

    return determine_routing_path
  ensure
    I18n.locale = _locale
    I18n.locale_source = _locale_source
  end

private

  def determine_routing_path

    Rails.logger.debug "[I18n]: try one available locale..."
    if m = one_available_locale?
      @env['rack.locale']           = m[0]
      @env['lalala.cannonical_url'] = nil
      @env['lalala.locale.source']  = 'default'
      return action(true)
    end

    Rails.logger.debug "[I18n]: try one available locale for hostname..."
    if m = hostname_with_one_available_locale?
      @env['rack.locale']           = m[0]
      @env['lalala.cannonical_url'] = nil
      @env['lalala.locale.source']  = 'host'
      return action(true)
    end

    Rails.logger.debug "[I18n]: try first path component..."
    if m = first_path_component_is_locale?
      @env['rack.locale']           = m[0]
      @env['SCRIPT_NAME']           = m[1]
      @env['PATH_INFO']             = m[2]
      @env['lalala.cannonical_url'] = nil
      @env['lalala.locale.source']  = 'path'
      return action(true)
    end

    if @adapter.allow_accept_language
      Rails.logger.debug "[I18n]: try Accept-Language..."
      if m = accept_language_is_available?
        @env['rack.locale']           = m[0]
        @env['SCRIPT_NAME']           = m[1]
        @env['lalala.cannonical_url'] = m[2]
        @env['lalala.locale.source']  = 'header'
        return action(false)
      end
    end

    @env['rack.locale'] = default_locale_for_hostname.to_sym
    @env['lalala.locale.source']  = 'default'
    return action(true)
  end

  def action(deterministic)
    action, new_env = @adapter.action(@env, deterministic)

    case action

    when :call
      I18n.locale        = new_env['rack.locale'].to_sym
      I18n.locale_source = new_env['lalala.locale.source']

      status, headers, body = @app.call(new_env)
      headers['Content-Language'] = I18n.locale.to_s
      headers['Canonical-URL'] = [headers['Canonical-URL'], @env['lalala.cannonical_url']]

      return [status, headers, body]

    when :redirect
      return [301, {'Location' => canonical_url}, []]

    end
  end

  def one_available_locale?
    if available_locales.size == 1
      return [available_locales.first.to_sym]
    end

    return nil
  end

  def hostname_with_one_available_locale?
    if locales_for_hostname.size == 1
      return [locales_for_hostname.first.to_sym]
    end

    return nil
  end

  def first_path_component_is_locale?
    if locale_regex === path_info
      locale = $1
      path   = $2 || ""

      path = "/" if path == ""

      script_name = File.join(@env['SCRIPT_NAME'].to_s, locale.to_s)

      return [locale.to_sym, script_name, path]
    end

    return nil
  end

  def accept_language_is_available?
    header = @env['HTTP_ACCEPT_LANGUAGE'] || ""

    accepted_locales = header.split(",")
    accepted_locales = accepted_locales.map do |l|
      l = l.strip
      l = l.split(";q=")
      l[0] = l[0].split('-').first
      l.push "1.0" if l.size < 2
      l
    end

    accepted_locales = accepted_locales.sort_by do |(_, qval)|
      qval.to_f * -1.0
    end

    accepted_locales = accepted_locales.map do |(locale, _)|
      locale
    end

    accepted_locale = accepted_locales.detect do |locale|
      (locale == "*") or locales_for_hostname_set.include?(locale)
    end

    if accepted_locale == "*"
      accepted_locale = nil
    end

    if accepted_locale
      script_name = File.join(@env['SCRIPT_NAME'].to_s, accepted_locale.to_s)

      url_env = @env.dup
      url_env['SCRIPT_NAME'] = script_name
      url = Rack::Request.new(url_env).url

      return [accepted_locale.to_sym, script_name, url]
    end

    return nil
  end

  def default_locale
    @_default_locale ||= @adapter.default_locale
  end

  def default_locale_for_hostname
    @_default_locale_for_hostname ||= begin
      l = @adapter.default_locale_for_hostname(hostname)

      unless l
        if locales_for_hostname.include?(default_locale)
          l = default_locale
        else
          l = locales_for_hostname.first
        end
      end

      unless l
        l = default_locale
      end

      l
    end
  end

  def available_locales
    @_available_locales ||= @adapter.available_locales
  end

  def locales_for_hostname
    @_locales_for_hostname ||= @adapter.locales_for_hostname(hostname)
  end

  def locales_for_hostname_set
    @_locales_for_hostname_set ||= locales_for_hostname.map(&:to_s)
  end

  def locale_for_ignored
    @_locale_for_ignored ||= @adapter.locale_for_ignored
  end

  def hostname
    @_hostname ||= @env['HTTP_HOST'].split(':').first
  end

  def path_info
    @_path_info ||= @env['PATH_INFO']
  end

  def locale_regex
    @_locale_regex ||= begin
      locales = locales_for_hostname
      locales = locales.map do |locale|
        Regexp.escape(locale.to_s)
      end
      locales = locales.join("|")

      %r{^/(#{locales})([/].*)?$}
    end
  end

end
