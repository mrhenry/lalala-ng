class Formtastic::Inputs::GridInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    assets = object.send(method)

    ul = template.content_tag :ul do
      html = template.raw("")

      assets.each do |asset|
        html += template.content_tag :li do
          builder.fields_for(method, asset) do |f|
            thumbnail_html = template.image_tag f.object.asset.thumb.url
            template.link_to thumbnail_html, f.object.asset.url
          end
        end
      end

      html += template.content_tag :li do
        builder.fields_for(method, assets.build) do |f|
          f.file_field :asset
        end
      end

      html
    end

    input_wrapping { ul }
  end
end
