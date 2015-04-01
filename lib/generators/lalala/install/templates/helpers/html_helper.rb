module HtmlHelper

  # Returns class_name if x equals y
  #
  # @param {String}   class_name
  # @param {Mixed}    x
  # @param {Mixed}    y
  # @param {Boolean}  exact
  #
  # @return {String}
  def css_class(class_name, x, y = true, exact = false)
    if exact
      class_name if (x === y)

    else
      class_name if (x == y)

    end
  end


  # Returns CSS body class
  # By default it shows the current controller & action
  # You can add items by using @body_class
  #
  # @return {String}
  def body_class
    body_class = [ params[:controller], params[:action] ]
    body_class << @body_class if @body_class
    body_class.join(" ")
  end


  # Return CSS background-image style
  #
  # @return {String}
  def css_bg_img(img_url = nil)
    "background-image: url('#{img_url}');"
  end


  # Returns HTML for all favicons links
  # Generate icons & code: http://iconogen.com/
  #
  # @return {String}
  def favicons
    raw <<-HEREDOC
      <link rel="shortcut icon" href="/assets/favicon.ico" type="image/x-icon" />
      <link rel="apple-touch-icon" sizes="57x57" href="/assets/apple-touch-icon-57x57.png">
      <link rel="apple-touch-icon" sizes="60x60" href="/assets/apple-touch-icon-60x60.png">
      <link rel="apple-touch-icon" sizes="72x72" href="/assets/apple-touch-icon-72x72.png">
      <link rel="apple-touch-icon" sizes="76x76" href="/assets/apple-touch-icon-76x76.png">
      <link rel="apple-touch-icon" sizes="114x114" href="/assets/apple-touch-icon-114x114.png">
      <link rel="apple-touch-icon" sizes="120x120" href="/assets/apple-touch-icon-120x120.png">
      <link rel="apple-touch-icon" sizes="144x144" href="/assets/apple-touch-icon-144x144.png">
      <link rel="apple-touch-icon" sizes="152x152" href="/assets/apple-touch-icon-152x152.png">
      <link rel="apple-touch-icon" sizes="180x180" href="/assets/apple-touch-icon-180x180.png">
      <link rel="icon" type="image/png" href="/assets/favicon-16x16.png" sizes="16x16">
      <link rel="icon" type="image/png" href="/assets/favicon-32x32.png" sizes="32x32">
      <link rel="icon" type="image/png" href="/assets/favicon-96x96.png" sizes="96x96">
      <link rel="icon" type="image/png" href="/assets/android-chrome-192x192.png" sizes="192x192">
      <meta name="msapplication-square70x70logo" content="/assets/smalltile.png" />
      <meta name="msapplication-square150x150logo" content="/assets/mediumtile.png" />
      <meta name="msapplication-wide310x150logo" content="/assets/widetile.png" />
      <meta name="msapplication-square310x310logo" content="/assets/largetile.png" />
    HEREDOC
  end


  # Includes inline SVG
  #
  # @param {String} path
  #
  # @return {String}
  def inline_svg(path)
    File.open("app/assets/images/#{path}", "rb") do |file|
      raw file.read
    end
  end


  # When on .mrhenry.eu domain, we don't want a search crawler to index
  #
  # @return {String}
  def meta_name_robots
    if request.host.match /.*\.a\.mrhenry\.eu.*/
      tag("meta", name: "robots", content: "noindex, nofollow")

    else
      tag("meta", name: "robots", content: "index, follow")

    end
  end


  # Render partial
  #
  def render_partial(partial_name, locals={}, &block)
    render partial: partial_name, locals: locals.merge({ block: block })
  end

end
