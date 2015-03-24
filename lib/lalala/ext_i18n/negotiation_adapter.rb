class Lalala::ExtI18n::NegotiationAdapter

  def default_locale
    I18n.default_locale
  end

  def available_locales
    I18n.available_locales || []
  end

  def default_locale_for_hostname(hostname)
    nil
  end

  def locale_for_ignored
    default_locale
  end

  def locales_for_hostname(hostname)
    available_locales
  end

  def action(env, deterministic)
    return [:call, env]
  end

  def ignored?(env)
    %r{^/(lalala|assets)(/|$)} === env['PATH_INFO']
  end

  def allow_accept_language
    !!Rails.configuration.lalala.i18n.allow_accept_language
  end

end
