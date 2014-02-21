module Lalala::Assets::List

  def self.build(params)
    klass = params[:klass]
    collection = []

    if klass
      id = params[:id]
      association = params[:association]

      if id and association
        assets = klass.constantize.find(id).try(association.to_sym)
        collection = assets.map { |asset| build_item(asset) }
      end

    else
      # TODO - GET ALL IMAGES/MEDIA/ASSETS
      # model_classes = ActiveRecord::Base.descendants.map(&:name)

    end
  end


  def self.build_item(haraway_asset)
    versions = {}

    # TODO
    # haraway_asset.versions.each do |version, attributes|
    #   versions[version] = attributes
    # end

    versions = haraway_asset.version

    # final
    return {
      uuid: haraway_asset.uuid,
      attributes: haraway_asset.attributes,
      url: haraway_asset.url,
      versions: versions
    }
  end

end
