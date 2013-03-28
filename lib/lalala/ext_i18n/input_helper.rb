module Lalala::ExtI18n::InputHelper

  def input(method, options = {})
    unless translated?(method)
      return super(method, options)
    end

    begin
      _locale, _object_name = I18n.locale, @object_name

      h = "".html_safe

      locales = I18n.available_locales.dup
      locales.sort!

      if I18n.default_locale
        locales.delete(I18n.default_locale)
        locales.unshift(I18n.default_locale)
      end

      opts = options.dup
      if opts[:wrapper_html]
        opts[:wrapper_html] = opts[:wrapper_html].dup
      else
        opts[:wrapper_html] = {}
      end

      opts[:wrapper_html][:class] = [
        opts[:wrapper_html][:class],
        "translated"
      ].flatten.compact

      locales.each do |locale|
        I18n.locale  = locale
        @object_name = "#{_object_name}[translations_writer][#{locale}]"


        opts[:wrapper_html][:'data-locale'] = locale.to_s

        h << super(method, opts)
      end

      h

    ensure
      I18n.locale, @object_name = _locale, _object_name
    end
  end

protected

  def column_for(method) #:nodoc:
    if translated?(method)
      c = @object.class.translation_class.columns_hash[method.to_s]
      return c if c
    end

    super(method)
  end

  def translated?(method)
    @object.respond_to?(:translated?) and @object.translated?(method)
  end

end
