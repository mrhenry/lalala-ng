class Lalala::Markdown::Handlers::Mixcloud < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    options.assert_valid_keys(:width, :height)

    options = {
      width:  670,
      height: 120
    }.merge(options)

    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^mixcloud[:]//(.+)$| === url
      return ""
    end

    id = $1

    helpers.content_tag :span, class: "embed-container is-mixcloud" do
      helpers.content_tag(
        :iframe,
        "",
        class:          "mixcloud-embed js-mixcloud-embed",
        width:           "100%",
        height:          @options[:height],
        src:             "//www.mixcloud.com/widget/iframe/?feed=#{id}&hide_cover=1&light=1",
        frameborder:     0,
        allowfullscreen: true
      )
    end
  end

end
