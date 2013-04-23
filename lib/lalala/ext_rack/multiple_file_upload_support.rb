class Lalala::ExtRack::MultipleFileUploadSupport

  METHODS = /^POST|PUT|PATCH$/

  def initialize(app)
    @app = app
  end

  def call(env)
    if METHODS === env["REQUEST_METHOD"]
      params = env["rack.request.form_hash"]
      correct_assets_hash_nesting(params)
    end

    @app.call(env)
  end

  def correct_assets_hash_nesting(params, key=nil)
    if key and key.to_s.ends_with?("_attributes")
      return if params.size == 0

      last_id = params.keys.sort_by(&:to_i).last
      last_id = "#{last_id}"

      return if params[last_id]["asset"].nil?

      last = params.delete(last_id)
      assets = last["asset"]

      return unless Array === assets

      assets.each do |file|
        params[last_id] = { "asset" => file }.with_indifferent_access
        last_id.succ!
      end

    else
      case params
      when Hash then params.each { |k, v| correct_assets_hash_nesting(v, k) }
      when Array then params.each { |v| correct_assets_hash_nesting(v) }
      end

    end
  end

end
