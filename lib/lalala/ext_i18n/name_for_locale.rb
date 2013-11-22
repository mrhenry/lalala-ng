module Lalala::ExtI18n::NameForLocale

  def self.name_for_locale(locale)
    I18n.backend.translate(locale, "i18n.languages.#{locale}", default: locale.to_s)
  rescue I18n::MissingTranslationData
    locale.to_s
  end

end
