class Lalala::Views::TitleBar < ActiveAdmin::Views::TitleBar

  def build_titlebar_right
    div :id => "titlebar_right" do
      build_locale_dropdown
      build_action_items
    end
  end

  def build_locale_dropdown
    return unless I18n.available_locales.size > 1

    locales = I18n.available_locales.dup
    locales.sort!

    div :class => "locale_chooser" do
      select(class: "bypass-chosen") do

        locales.each do |locale|
          opts = { :value => locale.to_s }
          opts[:'data-default'] = "true" if I18n.default_locale == locale
          opts[:'data-current'] = "true" if I18n.locale == locale
          option opts do
            text_node Lalala::ExtI18n::NameForLocale.name_for_locale(locale)
          end
        end

      end
    end
  end

end
