require File.dirname(__FILE__) + '/../test_helper'

class LoginIntegrationTest < ActionDispatch::IntegrationTest

  def setup
    AdminUser.create! email: 'admin@example.com', password: 'password', password_confirmation: 'password'
  end

  test 'when not loged in whe should be redirected to the login page' do
    visit('/lalala/pages')
    assert_equal(new_admin_user_session_path, current_path)
  end

  test 'login' do
    visit('/lalala/pages')
    assert_equal(new_admin_user_session_path, current_path)
    fill_in('Email',    with: 'admin@example.com')
    fill_in('Password', with: 'password')
    click_on('Login')
    assert_equal(lalala_pages_path, current_path)
  end

end
