class Formtastic::Inputs::MultipleFilesInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object

    klass = Formtastic::Inputs::MultipleFilesInput
    param_key = "#{object.class.table_name.singularize}[#{method}]"
    title = method.to_s.pluralize.titleize
    assets = object.send(method)

    defn = object.class.haraway_assets[method.to_s]
    accepts = defn.profile.try(:accepted_file_types)
    accepts = accepts.join(", ") if accepts
    versions = compile_versions_array(defn.profile)

    sorted_assets = klass.sorted_assets(assets.clone).map do |asset|
      klass.xfile_html(self, template, param_key, asset, versions)
    end

    <<-HTML

    <x-files multiple-files profile="#{defn.profile.name}" accept="#{accepts}" name="#{param_key}">
      <header>
        <div class="col-a">
          <span class="name">#{title}</span>
          <a class="choose">Browse files</a>
        </div>
        <div class="col-b">
          <div class="info-button"></div>
          <div class="data-inspection"></div>
        </div>
      </header>

      <template class="x-file-template">
        <div class="title"></div>
        <div class="status-bar">
          <div class="upload-bar"></div>
          <div class="process-bar"></div>
        </div>

        #{ klass.menu_html }
      </template>

      <template class="form-template">
        #{ asset_attributes_form(template, param_key) }
      </template>

      <div class="file-container">
        <div class="inner-wrapper">
          #{ sorted_assets.join("") }
        </div>
      </div>

      <div class="meta-versions">
        #{ versions_html(defn.profile) }
      </div>
    </x-files>

    HTML
  end


  def asset_attributes_form(template, param_key, asset=nil)
    if block = @options[:block]
      h = @builder.semantic_fields_for(@method, asset, index: "", &block)
    else
      h = ""
    end

    # select
    h.gsub!("<select ", "<select class=\"bypass-chosen\" ")

    # return
    h
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


  def versions_html(profile)
    compile_versions_array(profile).map do |version|
      <<-HTML
        <script class="version" data-name="#{version.name}" type="application/json">
          #{version.params.to_json}
        </script>
      HTML
    end.join("")
  end


  #
  #  Utilities
  #
  def self.sorted_assets(array)
    array
  end


  def self.xfile_html(input, template, param_key, asset, versions)
    asset_url_original = asset.url(:original)

    # thumb
    if versions.select { |v| v.name == "thumb" }.length >= 1
      asset_url_thumb = asset.url(:thumb)
    end

    if asset_url_thumb
      thumb_html = "<div class=\"thumb\" style=\"background-image: " +
                   "url(#{ asset_url_thumb });\"></div>"
    else
      thumb_html = "<div class=\"thumb no-image\"></div>"
    end

    # return
    <<-HTML

    <x-file class="uploaded saved-to-db" data-src-original="#{ asset_url_original }">
      #{ thumb_html }

      <div class="attributes">
        #{ input.asset_attributes_form(template, param_key, asset) }
      </div>

      #{ Formtastic::Inputs::MultipleFilesInput.menu_html }
      #{ template.hidden_field_tag(param_key + "[][file_name]", asset.file_name) }
      #{ template.hidden_field_tag(param_key + "[][id]", asset.id) }
      #{ template.hidden_field_tag(param_key + "[][_destroy]", "") }

      <div class="title">
        #{ asset.file_name }
      </div>

      <div class="meta">
        <div class="row"></div>
      </div>
    </x-file>

    HTML
  end


  def self.menu_html
    <<-HTML

    <div class="menu">
      <a data-action="delete"></a>
      <a data-action="meta"></a>
      <a data-action="move"></a>
    </div>

    HTML
  end

end
