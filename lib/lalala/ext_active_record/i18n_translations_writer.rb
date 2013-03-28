module Lalala::ExtActiveRecord::I18nTranslationsWriter
  extend ActiveSupport::Concern

  module ClassMethods
    def translates(*attr_names)
      init = translates?

      result = super(*attr_names)

      if init
        include Writer
        attr_accessible :translations_writer
      end

      result
    end
  end

  module Writer
    def translations_writer=(attributes)
      _locale = I18n.locale

      I18n.available_locales.each do |locale|
        I18n.locale = locale
        attrs = attributes[locale.to_s]
        if attrs
          self.assign_attributes(attrs)
        end
      end

      attributes
    ensure
      I18n.locale = _locale
    end
  end

end

