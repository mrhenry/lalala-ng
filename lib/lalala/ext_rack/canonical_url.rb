class Lalala::ExtRack::CanonicalURL

  require 'uri'

  LINKS_HEADER = "Links"

  def initialize(app)
    @app = app
  end

  def call(env)
    dup._call(env)
  end

protected

  def _call(env)
    req_url = Rack::Request.new(env).url

    status, headers, body = @app.call(env)

    # prepare canonical urls
    urls = headers.delete('Canonical-URL')
    urls = [urls, req_url].flatten.compact
    urls = urls.map { |u| URI.parse(u) }

    # resolve canonical url
    url = urls.reverse.inject(urls.pop) do |acc, u|
      acc.merge(u)
    end
    url = url.to_s

    # if the canonical url is not the current url
    if url != req_url

      # set the canonical url
      links = [headers[LINKS_HEADER]].flatten.compact
      links << "<#{url}>; rel=\"canonical\""
      links = links.join(", ")
      headers[LINKS_HEADER] = links
    end

    return [status, headers, body]
  end

end
