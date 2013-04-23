class Lalala::Uploaders::File < CarrierWave::Uploader::Base

  def store_dir
    if Rails.env.production? or Rails.env.staging?
      "#{model.class.to_s.underscore}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.id}"
    end
  end

  def url(*)
    if Rails.env.production? or Rails.env.staging?
      File.join("/storage/assets", super)
    else
      super
    end
  end

end
