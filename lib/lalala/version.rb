module Lalala
  VERSION = "4.1.0"
  BUILD   = "{{BUILD_NUMBER}}"

  if BUILD != ("{{BUILD_NUMBER" + "}}") # prevent sed replacement (see script/ci)
    BUILD_VERSION = "#{VERSION}.dev.#{BUILD}"
  else
    BUILD_VERSION = VERSION
  end
end
