class Lalala::Markdown::Handlers::Vimeo < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    options.assert_valid_keys(:width, :height)

    options = {
      width:  560,
      height: 315
    }.merge(options)

    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^vimeo[:]//(.+)$| === url
      return ""
    end

    id = $1

    helpers.content_tag(
      :iframe,
      "",
      width:           @options[:width],
      height:          @options[:height],
      src:             "//player.vimeo.com/video/#{id}",
      frameborder:     0,
      allowfullscreen: true
    )
  end

end
