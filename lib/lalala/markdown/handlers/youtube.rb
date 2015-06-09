class Lalala::Markdown::Handlers::YouTube < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    options.assert_valid_keys(:width, :height)

    options = {
      width:  560,
      height: 315
    }.merge(options)

    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^youtube[:]//(.+)$| === url
      return ""
    end

    id = $1

    helpers.content_tag :span, class: "embed-container is-youtube" do
      helpers.content_tag(
        :iframe,
        "",
        width:           @options[:width],
        height:          @options[:height],
        src:             "http://www.youtube.com/embed/#{id}?rel=0",
        frameborder:     0,
        allowfullscreen: true
      )
    end


  end

end
