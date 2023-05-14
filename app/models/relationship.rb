class Relationship < ApplicationRecord
  #いいね機能
    belongs_to :follower, class_name: "User"
    belongs_to :followed, class_name: "User"
  
    validates :follower_id, presence: true
    validates :followed_id, presence: true
  end
  