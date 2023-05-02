class CommentsController < ApplicationController
    before_action :set_post
   def create
     @post = Post.find(params[:post_id])
     @comment = @post.comments.new(comment_params)
     @comment.user = current_user
     if @comment.save
       redirect_to @post
     else
       flash[:error] = "コメント作成に失敗しました"
       redirect_to @post
     end
     
   end
   
    def destroy
      @comment = @post.comments.find(params[:id])
      @comment.destroy
      redirect_to @post
    end
  
    private
      
      def set_post
        @post = Post.find(params[:post_id])
      end
  
      def comment_params
        params.require(:comment).permit(:content)
      end
  end
  