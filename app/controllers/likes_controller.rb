class LikesController < ApplicationController
    before_action :set_post
  
   def create
     @like = current_user.likes.find_or_initialize_by(post: @post) # ユーザーがすでに投稿を「いいね」していれば@likeにそのレコードを代入し、していなければ新規作成する
     
     if @like.persisted? # すでに存在している場合は削除し、メッセージを表示する
       @like.destroy
       redirect_back fallback_location: root_path, notice: "投稿のいいねを取り消しました。"
     elsif @like.save # 新規作成できた場合
       redirect_back fallback_location: root_path, notice: "投稿をいいねしました！"
     else
       redirect_back fallback_location: root_path, alert: "投稿のいいねに失敗しました。"
     end
   end
   
  
    def destroy
      @like = current_user.likes.find_by(post: @post)
      @like.destroy
  
      redirect_back fallback_location: root_path, notice: "いいねを削除しました。"
    end
  
    private
  
    def set_post
      @post = Post.find(params[:post_id])
    end
  end
  