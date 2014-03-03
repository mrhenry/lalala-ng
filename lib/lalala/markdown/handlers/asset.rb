class Lalala::Markdown::Handlers::Asset < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^asset[:]//(.+)$| === url
      return ""
    end

    id_with_version = $1.split("/")
    id = id_with_version[0]
    version = id_with_version[1] || "original"

    url = "//" + File.join(
      "c." + Haraway.configuration.endpoint,
      id,
      version.to_s)

    "<img src=\"#{url}\" alt=\"#{alt}\" title=\"#{title}\" />"
  end

end
