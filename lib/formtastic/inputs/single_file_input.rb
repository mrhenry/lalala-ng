class Formtastic::Inputs::SingleFileInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    param_key = "#{object.class.table_name.singularize}[#{method}]"
    title = method.to_s.titleize
    asset = object.send(method)

    defn = object.class.haraway_assets[method.to_s]
    accepts = defn.profile.try(:accepted_file_types)
    accepts = accepts.join(", ") if accepts
    versions = compile_versions_array(defn.profile)

    <<-HTML

    <x-files single-file profile="#{defn.profile.name}" accept="#{accepts}" name="#{param_key}">
      <div class="association">#{ title }</div>

      <div class="buttons">
        <a class="choose">Browse file</a>
      </div>

      <div class="content">
        <div class="image">#{ asset ? image_html(asset, versions) : "" }</div>
        <div class="status">
          <div class="status-title"></div>
          <div class="status-bar">
            <div class="upload-bar"></div>
            <div class="process-bar"></div>
          </div>
        </div>
        <div class="name"></div>
      </div>
    </x-files>

    HTML
  end


  def compile_versions_array(profile)
    if profile
      versions = profile.versions.keys.map do |key|
        version = profile.versions[key.to_s]

        OpenStruct.new(
          name: version.name,
          params: version.steps.first.try(:[], "params")
        )
      end.compact

    else
      versions = []

    end

    # return
    versions
  end


  def image_html(asset, versions)
    if versions.select { |v| v.name == "thumb" }.length >= 1
      asset_url_thumb = asset.url(:thumb)
    end

    if asset_url_thumb
      html = "<div class=\"thumb\" style=\"background-image: " +
                   "url(#{ asset_url_thumb });\"></div>"
    else
      html = "<div class=\"thumb no-image\"></div>"
    end

    html
  end

end
