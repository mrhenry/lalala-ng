module Lalala::Markdown::InputHelper
  extend ActiveSupport::Concern

  def input(method, options = {})
    if @object.respond_to?("#{method}_html")
      options = options.dup.clone

      input_html = options[:input_html] || {}
      input_html[:class] = [input_html[:class], 'markdown'].flatten.compact.join(" ")

      editor_options = options[:editor_options] || {}
      editor_options.each do |k, v|
        v = if v === true then "1" elsif v === false then "0" end
        input_html["editor-#{k.to_s.gsub("_", "-")}"] = v
      end

      options[:input_html] = input_html
    end

    super(method, options)
  end
end
