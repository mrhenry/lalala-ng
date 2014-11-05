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


  # Render partial
  #
  def render_partial(partial_name, locals={}, &block)
    render partial: partial_name, locals: locals.merge({ block: block })
  end

end
