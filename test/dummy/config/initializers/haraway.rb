Haraway.configure do |c|

  c.use_ssl    = false
  c.endpoint   = "assets.sh"
  c.access_key = "ab1cf520-f9fd-11e2-b778-0800200c9a66"
  c.secret_key = "ab1cf520-f9fd-11e2-b778-0800200c9a66"
  c.pusher_key = "2832a7b628da2ac2899c"

  #
  #  Profiles
  #
  c.profile("images") do |p|
    p.accept "image/*"

    p.version("thumb") do |v|
      v.resize_to_fill(100, 100)
    end

    p.version("banner") do |v|
      v.resize_to_fill(960, 300)
    end
  end

end
