 class PostsController < ApplicationController
  include Pagy::Backend
 before_action :paginate_posts, only: [:index, :most_liked, :show]
 before_action :set_user, only: [:destroy]
 before_action :check_user_and_post, only: [:show]
 
 def paginate_posts(posts_to_paginate = nil)
   @pagy, @posts = pagy(posts_to_paginate.presence || Post.all, items: 10)
 end
 
 def check_user_and_post
  # add your code here
end


  def new_action
      # アクション処理
  end
  
  
  def index
    order_by = params[:order_by] || ''
    @posts = case order_by
             when 'created_at_desc'
               Post.order(created_at: :desc)
             when 'created_at_asc'
               Post.order(created_at: :asc)
             when 'likes_desc'
               Post.joins(:likes).group(:id).order('COUNT(likes.id) DESC')
             else
               Post.all.order(created_at: :desc)
             end
    @posts = @posts.reverse_order if order_by == 'created_at_asc'
    @pagy, @posts = pagy(@posts, items:10)
  end

     

 


def new
  @post = Post.new
end

def create
  @post = current_user.posts.build(post_params)

  if @post.save
    flash[:success] = "投稿が作成されました"
    redirect_to @post
  else
    flash.now[:error] = "エラー：投稿を保存できませんでした - #{@post.errors.full_messages}"
    render :new
  end
end


def show
  @post = Post.find_by(id: params[:id])
  if !@post || !current_user
    flash[:error] = "投稿が見つかりませんでした。" if !@post
    flash[:alert] = "ログインしてください。" if !current_user
    redirect_to posts_path and return
  end

  @like = Like.find_by(user_id: current_user.id, post_id: @post.id) if current_user
  
  # コメントの表示に関するコードを追加
  @comment = Comment.new
  @pagy, @comments = pagy(@post.comments.order(created_at: :desc), items: 5)
end

def edit
  
end

def update
  if @post.update(post_params)
    redirect_to @post, notice: 'Post was successfully updated.'
  else
    render :edit
  end
end

def destroy
  @post = Post.find_by(id: params[:id])
  if @post.nil?
    flash[:alert] = "投稿が見つかりませんでした。"
    redirect_to root_path and return
  end

  if current_user.id != @post.user_id
    flash[:alert] = "投稿の所有者ではありません。"
    redirect_to root_path and return
  end

  if @post.destroy
    flash[:notice] = "投稿を削除しました。"
    redirect_to user_path(current_user)
  else
    flash[:alert] = "投稿の削除に失敗しました。"
    redirect_to user_path(current_user)
  end
end

def most_liked
  set_pagy_posts
  @posts = Post.left_joins(:likes)
               .select("posts.*, count(likes.id) as like_count")
               .group("posts.id")
               .order('like_count DESC')

  # 最も「いいね！」の数が多い投稿を取得し、その投稿を先頭に追加
  @most_liked_post = @posts.first
 
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

private

def post_params
  params.require(:post).permit(:image_url1,:image_url2,:image_url22,:image_url23,:image_url3,:image_url33,:image_url34,:content)
end

 def set_pagy_posts(posts)
   @pagy, @posts = pagy(posts)
 end


 def set_user
  if params[:user_id].present?
    @user = User.find_by(id: params[:user_id])
    unless @user
      # ユーザーが存在しない場合の処理
    end
  else
    # user_idパラメータが欠落している場合の処理
  end
end

def check_user_and_post
  @post = Post.find_by(id: params[:id])
  unless @post && current_user
    if !@post
      flash[:error] = "投稿が見つかりませんでした。"
    elsif !current_user
      flash[:alert] = "ログインしてください。"
    end
    redirect_to posts_path and return
  end

  


def login_required
  redirect_to login_url unless current_user
end
  

  # Other controller actions...


    
end
end

