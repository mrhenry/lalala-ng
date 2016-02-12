class Lalala::Markdown

  require 'lalala/markdown/preview'
  require 'lalala/markdown/active_model'
  require 'lalala/markdown/html_renderer'
  require 'lalala/markdown/markdown_renderer'
  require 'lalala/markdown/input_helper'

  module Handlers
    require 'lalala/markdown/handlers/base'
    require 'lalala/markdown/handlers/asset'
    require 'lalala/markdown/handlers/lazy_asset'
    require 'lalala/markdown/handlers/vimeo'
    require 'lalala/markdown/handlers/youtube'
    require 'lalala/markdown/handlers/soundcloud'
    require 'lalala/markdown/handlers/publitas'
  end

  PARSER_OPTIONS = [
    :autolink,
    :fenced_code_blocks,
    :lax_spacing,
    :no_intra_emphasis,
    :space_after_headers,
    :strikethrough,
    :superscript,
    :tables
  ]

  RENDERER_OPTIONS = [
    :filter_html,
    :hard_wrap,
    :link_attributes,
    :link_schemes,
    :no_images,
    :no_links,
    :no_styles,
    :safe_links_only,
    :with_toc_data,
    :xhtml
  ]

  OPTIONS = PARSER_OPTIONS + RENDERER_OPTIONS

  def initialize(options={})
    options.assert_valid_keys(*OPTIONS)

    @parser_options = options.slice(*PARSER_OPTIONS)
    @parser_options = {
      no_intra_emphasis: true,
      tables: true,
      fenced_code_blocks: true,
      autolink: true,
      strikethrough: true,
      lax_spacing: false,
      space_after_headers: false,
      superscript: true
    }.merge(@parser_options)

    @renderer_options = options.slice(*RENDERER_OPTIONS)
    @renderer_options = {
      filter_html: true,
      no_images: false,
      no_links: false,
      no_styles: true,
      safe_links_only: true,
      with_toc_data: true,
      hard_wrap: false,
      xhtml: false
    }.merge(@renderer_options)
  end

  def options
    {}.merge(@parser_options).merge(@renderer_options)
  end

  def render(text)
    md = parser(html_renderer)
    md.render(text)
  end

  def format(text)
    md = parser(markdown_renderer)
    md.render(text)
  end

private

  def parser(renderer)
    Redcarpet::Markdown.new(renderer, @parser_options)
  end

  def markdown_renderer
    Lalala::Markdown::MarkdownRenderer.new(@renderer_options)
  end

  def html_renderer
    Lalala::Markdown::HtmlRenderer.new(@renderer_options)
  end

end

ActiveSupport.on_load :active_record do
  ActiveRecord::Base.send :include, Lalala::Markdown::ActiveModel
end
