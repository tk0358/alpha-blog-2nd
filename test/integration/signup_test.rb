require 'test_helper'

class SignupTest < ActionDispatch::IntegrationTest


  test " valid user can sign up" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'ruru', email: 'ruru@example.com', password: 'password'} }
      follow_redirect!
    end
    assert_template 'users/show'
  end

  test "too-short name cannnot sign up" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: 'ru', email: 'ruru@example.com', password: 'password'} }
    end
    assert_template 'users/new'
    assert_select 'h2.panel-title'
  end
end