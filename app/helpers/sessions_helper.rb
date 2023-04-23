module SessionsHelper

    # ログイン時にセッションIDを付与する
    def log_in(user)
      session[:user_id] = user.id
    end
    
    # ユーザーのセッションを永続的にする(cookieに保存する)
    def remember(user)
      user.remember
      # cookies.permanent.encrypted[:user_id] = user.id
      # cookies.permanent[:remember_token] = user.remember_token
      # cookies の有効期限を 1ヶ月 にしたい場合
      cookies.encrypted[:user_id] = { value: user.id, expires: 1.month.from_now }
      cookies[:remember_token] = { value: user.remember_token, expires: 1.month.from_now }
    end
    
    # 記憶トークンcookieに対応するユーザーを返す
    def current_user
      if (user_id = session[:user_id])
        @current_user ||= User.find_by(id: user_id)
      elsif (user_id = cookies.encrypted[:user_id])
        user = User.find_by(id: user_id)
        if user && user.authenticated?(:remember, cookies[:remember_token])
          log_in user
          @current_user = user
        end
      end
    end
    
    # 現在ログインしているユーザーのユーザー情報を取得する
    # def current_user
    #   @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
    # end
    
    # ユーザーがログインしているかどうかをチェックする
    def logged_in?
      !current_user.nil?
    end
    
    # ログインしていないユーザーがアクセスできないようにする
    # ログイン画面にリダイレクトさせる
    def require_user
      if !logged_in?
        flash[:alert] = "ログインしてください。"
        redirect_to login_path
      end
    end
    
    # 永続的セッションを破棄する
    def forget(user)
      user.forget
      cookies.delete(:user_id)
      cookies.delete(:remember_token)
    end
    
    # ログアウトする（セッション情報を削除する）
    def log_out
      forget(current_user)
      session.delete(:user_id)
      @current_user = nil
    end
    
    end