module Lalala::Markdown::InputHelper
  extend ActiveSupport::Concern

  def input(method, options = {})
    if @object.respond_to?("#{method}_html")
      options = options.dup.clone

      input_html = options[:input_html] || {}
      input_html[:class] = [input_html[:class], 'markdown'].flatten.compact.join(" ")

      if defined?(Lalala::Markdown::Editor) &&
         defined?(Lalala::Markdown::Editor::SETTINGS)
        hash = Lalala::Markdown::Editor::SETTINGS
        input_html["editor-settings"] = hash.to_json
      end

      options[:input_html] = input_html
    end

    super(method, options)
  end

end
