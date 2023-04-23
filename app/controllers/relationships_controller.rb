class RelationshipsController < ApplicationController
    def create
        @user = User.find(params[:followed_id])
        current_user.follow(@user)
        redirect_to @user
     
        redirect_to root_path
      end
    end
    
       def destroy
         begin
           @user = Relationship.find(params[:id]).followed
           current_user.unfollow(@user)
           redirect_to @user
         rescue ActiveRecord::RecordNotFound
           flash[:error] = "フォローレコードが見つかりませんでした"
           redirect_to root_path
         end
       end
       
     