class Lalala::Markdown::HtmlRenderer < Redcarpet::Render::HTML

  URI_PATTERN = %r{\A(lalala|youtube|vimeo)[:][/]{2}.+\Z}

  def initialize(options)
    @options      = options.dup
    @link_schemes = (options[:link_schemes] || {}).dup
    super(options)
  end

  def autolink(link, link_type)
    if link.blank?
      return ""
    end

    if URI_PATTERN === link
      return enhanced_autolink($1, link, link_type)
    end

    if @options[:safe_links_only] and !safe_link(link) and link_type != :email
      return ""
    end

    url = link
    url = "mailto:"+url if link_type == :email

    helpers.link_to(link, url, @options[:link_attributes])
  end

  def image(link, title, alt_text)
    if link.blank?
      return ""
    end

    if URI_PATTERN === link
      return enhanced_image($1, link, title, alt_text)
    end

    if @options[:safe_links_only] and !safe_link(link)
      return ""
    end

    helpers.image_tag(link, alt: alt_text, title: title)
  end

  def link(link, title, content)
    if link.blank?
      link = nil
    end

    if link and URI_PATTERN === link
      return enhanced_link($1, link, title, content)
    end

    if link and @options[:safe_links_only] and !safe_link(link)
      return ""
    end

    options = (@options[:link_attributes] || {}).merge(title: title)
    helpers.link_to(content, link, options)
  end

  def enhanced_autolink(scheme, link, link_type)
    handler = @link_schemes[scheme]
    if handler
      handler.link(link, nil, nil)
    else
      ""
    end
  end

  def enhanced_image(scheme, link, title, alt_text)
    handler = @link_schemes[scheme]
    if handler
      handler.image(link, alt_text, title)
    else
      ""
    end
  end

  def enhanced_link(scheme, link, title, content)
    handler = @link_schemes[scheme]
    if handler
      handler.link(link, content, title)
    else
      ""
    end
  end

  def preprocess(doc)
    # custom markdown
    # haraway
    doc.gsub(/\{\{haraway\/([^\}]+)\}\}/) do
      # TODO: retrieve haraway asset by uuid
      uuid = $1
      "<img />"
    end
  end

private

  def safe_link(link)
    case link
    when %r{^/}
      return true
    when %r{^(http|https|ftp)[:]//}
      return true
    when %r{^mailto[:]}
      return true
    else
      return false
    end
  end

  def helpers
    ApplicationController.helpers
  end

end
