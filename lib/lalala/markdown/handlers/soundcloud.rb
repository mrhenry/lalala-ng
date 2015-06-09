class Lalala::Markdown::Handlers::Soundcloud < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    options.assert_valid_keys(:width, :height)

    options = {
      width:  560,
      height: 166
    }.merge(options)

    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^soundcloud[:]//(.+)$| === url
      return ""
    end

    id = $1

    helpers.content_tag :span, class: "embed-container is-soundcloud" do
      helpers.content_tag(
        :iframe,
        "",
        class:          "soundcloud-embed js-soundcloud-embed",
        width:           @options[:width],
        height:          @options[:height],
        src:             "//w.soundcloud.com/player/?auto_play=false&hide_related=true&show_comments=false&show_user=false&show_reposts=false&visual=false",
        :"data-url" =>   "https://soundcloud.com/oembed?format=json&url=https://soundcloud.com/#{id}",
        frameborder:     0,
        allowfullscreen: true
      )
    end
  end

end
