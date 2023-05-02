require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  # 新規ユーザー登録用の統合テスト
  # ユーザー登録時に（ユーザー情報が無効であるために）ユーザーが作成されないことを確認する
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      # users_pathに対してポストリクエストを送信する
      post users_path, params:
                      { user: { name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar" } }
    end
    # エラー発生時に signup_path をレンダリングしているかどうか
    assert_template "users/new"
    # エラー発生時に error クラスが追加されているかどうか
    assert_select 'div.field.error'
  end

  # ユーザー登録時にユーザーが作成されることを確認する
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user:
                    { name: 'test user',
                    email: 'test@example.com',
                    password: 'password',
                    password_confirmation: 'password' } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_template "users/show"
    # ユーザー登録後にログインできているかをテスト
    assert is_logged_in?
    # showページの指定タグ内にユーザー名が表示されているかをテスト
    assert_select "p.header", "test user"
    assert_select "div.ui.card>.content>.header", "test user"
    # showページにフラッシュメッセージが表示されているかをテスト
    assert_select "div.ui.message.success"
  end

end