class Lalala::Markdown::Handlers::Vimeo < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    options.assert_valid_keys(:color, :height, :show_badge, :show_byline, :show_portrait, :show_title, :width)

    options = {
      color: "ffffff",
      height: 315,
      show_badge: 0,
      show_byline: 0,
      show_portrait: 0,
      show_title: 0,
      width:  560
    }.merge(options)

    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^vimeo[:]//(.+)$| === url
      return ""
    end

    id = $1

    helpers.content_tag :span, class: "embed-container" do
      helpers.content_tag(
        :iframe,
        "",
        width:           @options[:width],
        height:          @options[:height],
        src:             "//player.vimeo.com/video/#{id}?portrait=#{@options[:show_portrait]}&title=#{@options[:show_title]}&badge=#{@options[:show_badge]}&byline=#{@options[:show_byline]}&color=#{@options[:color]}&wmode=transparent",

        frameborder:     0,
        allowfullscreen: true
      )
    end
  end

end
