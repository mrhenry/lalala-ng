require 'test_helper'

class LalalaI18nRouterTest < ActiveSupport::TestCase

  test "one locale" do
    @default_locale    = :nl
    @available_locales = { "example.com" => [:nl] }

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
      "HTTP_ACCEPT_LANGUAGE" => "en,nl"
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
      "rack.locale" => :nl
    })

  end

  test "one locale (for this domain)" do
    @default_locale    = :fr
    @available_locales = { "example.com" => [:de], "example.net" => [:nl, :fr] }

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :de
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :de
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
      "HTTP_ACCEPT_LANGUAGE" => "en,nl"
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :de
    })

    assert_route_to({
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
      "rack.locale" => :de
    })

  end

  test "default locale (for this domain)" do
    @default_locale    = :de
    @available_locales = { "example.com" => [:fr, :nl], "example.net" => [:de] }

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :fr
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :fr
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
      "HTTP_ACCEPT_LANGUAGE" => "en,de"
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => nil,
      "rack.locale" => :fr
    })

    assert_route_to({
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
      "rack.locale" => :fr
    })

  end

  test "other locale (for this domain)" do
    @default_locale    = :de
    @available_locales = { "example.com" => [:fr, :nl], "example.net" => [:de] }

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/nl",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/",
      "SCRIPT_NAME" => "/nl",
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/nl/foo/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => "/nl",
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST" => "example.com",
      "PATH_INFO" => "/foo/bar",
      "HTTP_ACCEPT_LANGUAGE" => "en,nl"
    }, {
      "HTTP_HOST"   => "example.com",
      "PATH_INFO"   => "/foo/bar",
      "SCRIPT_NAME" => "/nl",
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/nl/bar",
    }, {
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo/nl",
      "PATH_INFO"   => "/bar",
      "rack.locale" => :nl
    })

    assert_route_to({
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo",
      "PATH_INFO"   => "/bar",
      "HTTP_ACCEPT_LANGUAGE" => "en,nl"
    }, {
      "HTTP_HOST"   => "example.com",
      "SCRIPT_NAME" => "/foo/nl",
      "PATH_INFO"   => "/bar",
      "rack.locale" => :nl
    })

  end

private

  def assert_route_to(a, b)
    o_env   = nil

    a = a.merge("rack.url_scheme" => "http")

    adapter = Lalala::ExtI18n::TestNegotiationAdapter.new(@default_locale, @available_locales)
    app     = ->(env){ o_env = env ; [-1, {}, []] }
    router  = Lalala::ExtRack::I18nNegotiator.new(app, adapter)

    router.call(a)

    b.each do |k, v|
      assert_equal(v, o_env[k])
    end
  end

end
