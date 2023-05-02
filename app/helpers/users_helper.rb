module UsersHelper
    def require_same_user
        if current_user != @user
          flash[:alert] = "許可されていない操作です。プロフィールの編集、削除は作成者ご自身のみ可能です。"
          redirect_to @user
        end
      end
end
