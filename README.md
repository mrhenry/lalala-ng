# Lalala [![Build Status](https://secure.travis-ci.org/mrhenry/lalala-ng.png)](http://travis-ci.org/mrhenry/lalala-ng?branch=master) [![Dependency Status](https://gemnasium.com/mrhenry/lalala-ng.png)](https://gemnasium.com/mrhenry/lalala-ng) [![Gem Version](https://badge.fury.io/rb/lalala.png)](http://badge.fury.io/rb/lalala) [![Code Climate](https://codeclimate.com/github/mrhenry/lalala-ng.png)](https://codeclimate.com/github/mrhenry/lalala-ng)

TODO: Write a gem description

## Installation

Make sure you have rails 3.X installed. Then run the generator:

    rails new [APP_NAME] -b https://raw.github.com/mrhenry/lalala-ng/master/lib/lalala/utils/install_template.rb

Or you can install a specific version:

    rails _3.2.15_ new [APP_NAME] -b https://raw.github.com/mrhenry/lalala-ng/master/lib/lalala/utils/install_template.rb


## Configuration

| ENV | values | description |
| ---- | ---- | ---- |
| RAILS_ENV | `"development"`, `"test"`, `"staging"`, `"production"` | Environment for Rails app |
| RACK_ENV  | `"development"`, `"test"`, `"staging"`, `"production"` | Environment for Rails app |
| APP_NAME | `<string>` | Name of the application |
| LALALA_S3_ACCESS_KEY | `<string>` | The AWS S3 access key |
| LALALA_S3_SECRET_KEY | `<string>` | The AWS S3 secret key |
| LALALA_S3_BUCKET | `<string>` | Name of the S3 bucket |

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

