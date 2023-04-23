class UsersController < ApplicationController
    include Pagy::Backend
    before_action :set_user, only: %i[ show edit update destroy ]
    before_action :require_user, only: [:edit, :update, :destroy]
    before_action :require_same_user, only: [:edit, :update, :destroy]
    helper_method :current_user
    before_action :admin_user, only: :destroy
    before_action :paginate_users, only: [:index]
    before_action :paginate_posts, only: [ :most_liked, :show]
    def paginate_posts(posts_to_paginate = nil)
      @pagy, @posts = pagy(posts_to_paginate.presence || Post.all, items: 10)
    end
    
    require 'pagy'
    def paginate_users(users_to_paginate = nil)
      @pagy, @users = pagy(users_to_paginate.presence || User.all, items: 10)
    end
   
    def index
      @pagy_users, @users = pagy(User.order(created_at: :desc), items: 10)
    end
   
    def follow
      @users = User.includes(:followers)
      @user = User.find(params[:id])
      current_user.follow(@user)
      redirect_to @user
    end
  
    def unfollow
      @users = User.includes(:followers)
      @user = User.find(params[:id])
      current_user.unfollow(@user)
      redirect_to @user
    end
  
    def show
      @user = User.find(params[:id])
      order_by = params[:order_by] || ''
      @posts = case order_by
               when 'created_at_desc'
                 @user.posts.order(created_at: :desc)
               when 'created_at_asc'
                 @user.posts.order(created_at: :asc)
               when 'likes_desc'
                 Post.joins(:likes).where(user_id: @user.id).group(:id).order('COUNT(likes.id) DESC')
               else
                 @user.posts.order(created_at: :desc)
               end
    
      @posts = @posts.reverse_order if order_by == 'created_at_asc'
      set_pagy_and_posts
    end
    
   
    
    def most_liked
      @posts = Post.left_joins(:likes)
                   .select("posts.*, count(likes.id) as like_count")
                   .group("posts.id")
                   .order('like_count DESC')
  
      # 最も「いいね！」の数が多い投稿を取得し、その投稿を先頭に追加
      @most_liked_post = @posts.first
  
      set_pagy_and_posts(@posts)
      render :index
    end
  
    def like
      if current_user.likes.find_by(post_id: params[:id])
        flash[:alert] = 'この投稿にはすでにいいねしています。'
      else
        Like.create(user_id: current_user.id, post_id: params[:id])
        flash[:notice] = '投稿にいいねしました。'
      end
      redirect_back(fallback_location: root_path)
    end
  
    def new
      @user = User.new
    end
  
    def edit
    end
  
    def create
      @user = User.new(user_params)
      if @user.save
        @user.send_activation_email
        flash[:notice] = "アカウント有効化メールを送信しました。メールが届きましたら、記載されているリンクをクリックしてアカウントを有効化してください。"
        redirect_to root_path
      else
        render :new, status: :unprocessable_entity
      end
    end
    
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to user_url(@user), notice: "ユーザーアカウントを編集しました。" }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def destroy
      if @user.destroy
        flash[:notice] = "ユーザーアカウントを削除しました。"
      else
        flash[:alert] = '投稿の削除に失敗しました。'
      end
      respond_to do |format|
        format.html { redirect_to users_path, status: :see_other }
        format.json { head :no_content }
      end
    end
    
    def new_guest
      if current_user
        redirect_to current_user, alert: "すでにログインしています" 
      else
        user = User.new_guest
        log_in user
        redirect_to root_url, notice: "ゲストとしてログインしました"
      end
    end
  
    def logout
      reset_session
      cookies.delete(:_fost-session) # ブラウザに保存された古いセッション情報が残る可能性があるため reset_session を呼び出す
      redirect_to root_path, notice: "ログアウトしました"
    end
  
    private
    
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def require_same_user
      if current_user != @user
        flash[:alert] = "許可されていない操作です。プロフィールの編集、削除は作成者ご自身のみ可能です。"
        redirect_to @user
      end
    end
  
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
  
    def require_user
      unless current_user.present?
        redirect_to login_path, alert: "ログインしてください"
      end
    end

    def set_pagy_and_users
      @pagy, @users = pagy(@users, items: 10, page: params[:page])
    end

   def set_pagy_and_posts
    @pagy, @posts = pagy(@posts, items: 10, page: params[:page])
  end
    
  end
  