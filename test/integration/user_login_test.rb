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
    # ユーザー "Tom" のメールアドレスを使用し、間違ったパスワードを入力してテスト
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

end
