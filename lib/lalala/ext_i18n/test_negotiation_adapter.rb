class Lalala::ExtI18n::TestNegotiationAdapter < Lalala::ExtI18n::NegotiationAdapter

  def initialize(default_locale, available_locales)
    @default_locale    = default_locale
    @available_locales = available_locales.values.flatten.compact.uniq
    @domain_locales    = available_locales
  end

  def default_locale
    @default_locale
  end

  def available_locales
    @available_locales
  end

  def locales_for_hostname(hostname)
    @domain_locales[hostname]
  end

  def allow_accept_language
    true
  end

end
