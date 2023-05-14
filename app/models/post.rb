class Post < ApplicationRecord
  scope :oldest_first, -> { order(created_at: :asc) }
  scope :most_liked, -> { joins(:likes).group(:id).order('COUNT(likes.id) DESC') }
  default_scope -> { order(created_at: :desc) }

  before_create :set_countdown_end_date
 
  
  belongs_to :user
  validates :user_id, presence: true
  #コメント機能


  validates :comments,
          length: { maximum: 100 }

has_many :comments, dependent: :destroy

validates :content,
          length: { maximum: 1000 }

  


  
  #必ず投稿しないといけないようにする
  validates :image_url1, :image_url2, :image_url3, :image_url40, presence: true
#任意機能
  validates :image_url22, presence: true, allow_blank: true
  validates :image_url23, presence: true, allow_blank: true
  validates :image_url33, presence: true, allow_blank: true
  validates :image_url34, presence: true, allow_blank: true
  
 #team
  validates :image_url41, presence: true, allow_blank: true
  validates :image_url42, presence: true, allow_blank: true
  validates :image_url43, presence: true, allow_blank: true
  validates :image_url44, presence: true, allow_blank: true


  validates :name, presence: true, allow_blank: true
   
 #いいね機能
  has_many :likes, dependent: :destroy
  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def likes_count
    likes.count
  end
#この機能とは
  def author
    User.find_by(id: user_id) if user_id.present?
  end
  

  def related_posts
    Post.where(user_id: user_id).where.not(id: id)
  end


end