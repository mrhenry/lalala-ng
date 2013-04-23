class Lalala::FileAsset < Lalala::AbstractAsset
  mount_uploader :asset, ::FileUploader
end
