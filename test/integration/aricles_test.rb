require File.dirname(__FILE__) + '/../test_helper'

class ArticlesTest < ActionDispatch::IntegrationTest

  def setup
    login_as_admin!
  end

  test 'list articles' do
    article = Article.create!(title: "Hello World")

    click_on('Articles')
    assert_equal 200, page.status_code
    assert page.assert_selector('a.resource_id_link', text: article.id.to_s)
  end

  test 'create article' do
    click_on('Articles')
    click_on('New Article')
    assert_equal('/lalala/articles/new', current_path)

    first('input[name="article[translations_writer][en][title]"]').set('My Article')
    attach_file('Image', File.expand_path('../../fixtures/files/image.png', __FILE__))
    click_on('Create Article')
    page.save_page
    assert_equal 200, page.status_code
    assert_equal('/lalala/articles/1', current_path)

    assert page.has_text?('My Article')
  end

end
