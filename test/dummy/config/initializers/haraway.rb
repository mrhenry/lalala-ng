Haraway.configure do |c|

  c.use_ssl    = false
  c.endpoint   = "assets.sh"
  c.access_key = "533019cfa622e91c"
  c.secret_key = "74bc88e1a0ab978b88d0c2a4b919f13ebe4a681a8f3a89e812182d09282d26a4"

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
