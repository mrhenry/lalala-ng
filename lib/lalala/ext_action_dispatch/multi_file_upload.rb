module Lalala::ExtActionDispatch::MultiFileUpload

private

  def normalize_parameters(value)
    value = super(value)

    if Hash === value
      value.each do |key, v|
        value[key] = correct_assets_hash_nesting(key, v)
      end
    end

    return value
  end

  def correct_assets_hash_nesting(key, value)
    unless key.to_s.ends_with?("_attributes")
      return value
    end

    unless Hash === value
      return value
    end

    if value.size == 0
      return value
    end

    last_id = value.keys.sort_by(&:to_i).last
    last_id = "#{last_id}"
    assets  = value[last_id].try(:[], "asset")

    unless Array === assets
      return value
    end

    unless assets.all?{ |i| ActionDispatch::Http::UploadedFile === i }
      return value
    end

    assets.each do |file|
      value[last_id] = { "asset" => file }.with_indifferent_access
      last_id.succ!
    end

    return value
  end

end
