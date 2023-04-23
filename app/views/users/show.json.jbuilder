json.partial! "users/user", user: @user
json.extract! @user, :id, :name, :email

json.stats do
  json.following_count @user.following.count
  json.followers_count @user.followers.count
end

if current_user && current_user != @user
  json.relationship do
    if current_user.following?(@user)
      json.action "unfollow"
      json.method "delete"
      json.path relationship_path(current_user.active_relationships.find_by(followed_id: @user.id))
    else
      json.action "follow"
      json.method "post"
      json.path relationships_path(followed_id: @user.id)
    end
  end
end

