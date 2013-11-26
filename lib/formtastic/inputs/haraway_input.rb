class Formtastic::Inputs::HarawayInput
  include Formtastic::Inputs::Base

  def to_html
    object = builder.object
    klass = Formtastic::Inputs::HarawayInput
    param_key = "#{object.class.table_name.singularize}[#{method}]"
    title = method.to_s.pluralize.titleize
    assets = object.send(method)

    sorted_assets = klass.sorted_assets(assets.clone).map do |asset|
      klass.xfile_html(self, template, param_key, asset)
    end

    # TODO: accept

    <<-EOT

    <x-files profile="#{method}" accept="image/*" name="#{param_key}">
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
    </x-files>

    EOT
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


  #
  #  Utilities
  #
  def self.sorted_assets(array)
    # fallback = 9999
    # array.sort do |a, b|
    #   a = a.instance_values["attributes"]["position"] || fallback
    #   b = b.instance_values["attributes"]["position"] || fallback

    #   a <=> b
    # end
    array
  end


  def self.xfile_html(input, template, param_key, asset)
    asset_url_original = (asset.url(:original) rescue "")
    asset_url_thumb = (asset.url(:thumb) rescue "")

    <<-EOT

    <x-file class="uploaded saved-to-db" data-src-original="#{ asset_url_original }">
      <div class="thumb" style="background-image: url(#{ asset_url_thumb });"></div>

      #{ Formtastic::Inputs::HarawayInput.menu_html }
      #{ template.hidden_field_tag(param_key + "[][uuid]", asset.uuid) }
      #{ template.hidden_field_tag(param_key + "[][_destroy]", "") }

      <div class="attributes">
        #{ input.asset_attributes_form(template, param_key, asset) }
      </div>

      <div class="meta">
        <div class="row">
          <span class="label">filetype</span>
          <span class="value">#{ asset.version(:original).extension }</span>
        </div>
      </div>
    </x-file>

    EOT
  end


  def self.menu_html
    <<-EOT

    <div class="menu">
      <a data-action="delete"></a>
      <a data-action="meta"></a>
      <a data-action="move"></a>
    </div>

    EOT
  end

end
