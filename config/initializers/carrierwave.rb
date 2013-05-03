#
#  Carrier Wave configuration block
#
CarrierWave.configure do |config|

  if (Rails.env.production? or Rails.env.staging?) and ENV["LALALA_S3_BUCKET"]

    config.storage = :fog
    config.root = Rails.root.join('tmp')
    config.cache_dir = 'uploads'

    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     ENV["LALALA_S3_ACCESS_KEY"],
      aws_secret_access_key: ENV["LALALA_S3_SECRET_KEY"]
    }

    config.fog_directory = File.join(
      ENV["LALALA_S3_BUCKET"],
      "storage",
      ENV["APP_NAME"],
      Rails.env.to_s,
      "assets"
    )

    config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}
    config.asset_host     = ""


  else # dev
    config.storage = :file

  end
end
