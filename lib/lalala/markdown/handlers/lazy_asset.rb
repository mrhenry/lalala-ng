class Lalala::Markdown::Handlers::LazyAsset < Lalala::Markdown::Handlers::Base

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

    # build url
    url = "//" + File.join(
      "c." + Haraway.configuration.endpoint,
      id,
      version.to_s)

    # build img element
    <<-EOS
      <img class="js-lazy" data-src="#{url}" alt="#{alt}" title="#{title}" />
    EOS
  end

end
