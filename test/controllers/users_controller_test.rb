require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  # fixture(users.yml)で作成したテスト用データーをセットする（ユーザー: Tom）
  def setup
    @user = users(:Tom)
  end

  # ログイン失敗時のテスト
  test "login with valid email/invalid password" do
    get login_path
    assert_template "sessions/new"
    post login_path, params:
                      { session: {
                            email: @user.email,
                            password: "invalid" } }
    assert_not is_logged_in?
    assert_template "sessions/new"
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  # ログイン成功〜ログアウトまでのテスト
  test "login with valid information followed by logout" do
    get login_path
    assert_template "sessions/new"
    post login_path, params:
                      { session: {
                            email: @user.email,
                            password: "password" } }
    assert is_logged_in?
    assert_redirected_to @user
    follow_redirect!
    assert_template "users/show"
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)

    # ログアウト後のテスト
    delete logout_path
    assert_not is_logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", user_path(@user), count: 0

  end

end