#
#  Carrier Wave configuration block
#
CarrierWave.configure do |config|

  if Rails.env.production? or Rails.env.staging?

    config.storage = :fog
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'uploads'

    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["LALALA_S3_ACCESS_KEY"],
      aws_secret_access_key: ENV["LALALA_S3_SECRET_KEY"]
    }

    config.fog_directory   = ENV["LALALA_S3_BUCKET"]
    config.fog_attributes  = {'Cache-Control'=>'max-age=315576000'}


  else # dev
    config.storage = :file

  end
end
