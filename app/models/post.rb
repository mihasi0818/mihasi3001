class Post < ApplicationRecord
  default_scope -> { order(created_at: :desc) } # 新しい順（created_atが最新のものから並べる）
  scope :oldest_first, -> { unscoped.order(created_at: :asc) } # 古い順
  scope :most_liked, -> { order(likes_count: :desc) } # いいね数が多い順

  belongs_to :user
  validates :user_id, presence: true
  validates :content,
            length: { maximum: 100 }
  validates :comments,
            length: { maximum: 100 }
  
  validates :image_url1, :image_url2, :image_url3, presence: true

  validates :image_url22, presence: true, allow_blank: true
  validates :image_url23, presence: true, allow_blank: true
  validates :image_url33, presence: true, allow_blank: true
  validates :image_url34, presence: true, allow_blank: true

  has_many :comments, dependent: :destroy

  has_many :likes, dependent: :destroy

  def liked_by?(user)
    likes.exists?(user_id: user.id)
  end

  def likes_count
    likes.count
  end

  def author
    User.find_by(id: user_id) if user_id.present?
  end

  def related_posts
    Post.where(user_id: user_id).where.not(id: id)
  end

end