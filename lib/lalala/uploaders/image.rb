class Lalala::Uploaders::Image < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  def store_dir
    if Rails.env.production? or Rails.env.staging?
      "#{model.class.to_s.underscore}/#{model.id}"
    else
      "uploads/#{model.class.to_s.underscore}/#{model.id}"
    end
  end

  def url(*)
    if Rails.env.production? or Rails.env.staging?
      File.join("/store/assets", super)
    else
      super
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
