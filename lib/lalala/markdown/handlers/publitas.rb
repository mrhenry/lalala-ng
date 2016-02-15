class Lalala::Markdown::Handlers::Publitas < Lalala::Markdown::Handlers::Base

  def initialize(options={})
    @options = options
  end

  def image(url, alt=nil, title=nil)
    unless %r|^publitas[:]//(.+)$| === url
      return ""
    end

    id = $1

    random = "publitas-embed-#{rand(1..9999999)}"

    helpers.content_tag :div, class: "embed-container" do
      content = helpers.content_tag(
        :div,
        "",
        id: random
      )

      content << helpers.content_tag(
        :script,
        "",
        {
          :"publitas-embed" => "publitas-embed",
          :"wrapperId" => random,
          :"data-wrapperId" => random,
          :"data-cfasync" => false,
          :"data-menu" => false,
          :"data-publication" => "https://view.publitas.com/#{id}",
          :"data-responsive" => true,
          type: "text/javascript",
          src: "https://view.publitas.com/embed.js"
        }
      )

      content
    end
  end

end
