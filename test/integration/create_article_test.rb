require 'test_helper'

class CreateArticleTest < ActionDispatch::IntegrationTest

  def setup
    @user = User.create(username: 'ruru', email: 'ruru@example.com', password: 'password')
    Category.create(name: 'category1')
    Category.create(name: 'category2')
  end

  test "valid article should be made" do
    sign_in_as(@user, 'password')
    get new_article_path
    assert_template 'articles/new'
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'test', description: 'a' * 15, category_ids: [1, 2]}}
      follow_redirect!
    end
    assert_template 'articles/show'
    assert_select 'h4.description'
  end

  test "invalid article shouldn't be made" do
    sign_in_as(@user, 'password')
    get new_article_path
    assert_template 'articles/new'
    assert_no_difference 'Article.count' do
      post articles_path, params: { article: { title: 'te', description: 'a' * 15, category_ids: [1, 2]}}
    end
    assert_template 'articles/new'
    assert_select 'div.panel-danger'
  end
end