class User < ApplicationRecord
  before_create :set_user_id
  #並び替え機能
    default_scope -> { order(created_at: :desc) } # 新しい順（created_atが最新のものから並べる）
    scope :oldest_first, -> { unscoped.order(created_at: :asc) } # 古い順
    scope :most_liked, -> { order(likes_count: :desc) } # いいね数が多い順
    paginates_per 10
    #いいね機能
    has_many :likes, dependent: :destroy
    # コメント機能
    has_many :comments, dependent: :destroy
    has_many :posts, dependent: :destroy
    # フォロー関係
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    # フォロワー関係
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :followers, through: :passive_relationships, source: :follower 
    #メール機能（記憶、送信、リセット）
    attr_accessor :remember_token, :activation_token, :reset_token
    before_save :downcase_email
    before_create :create_activation_digest
    # email　オブジェクトが保存される時点で小文字に変換する
    before_save { email.downcase! }
    # before_save { self.email = email.downcase }

    # name のバリデーション
    validates :name, presence: true, length: { maximum: 25 }
    
    # email のバリデーション
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence: true,
                      uniqueness: { case_sensitive: false },
                      length: { maximum: 105 },
                      format: { with: VALID_EMAIL_REGEX }
    
                      
    has_secure_password
    validates :password, presence: true,
              length: { minimum: 6 },
              allow_nil: true

              #フォロー機能
              def follow(other_user)
                following << other_user
              end
            
              def unfollow(other_user)
                following.delete(other_user)
              end
            
              def following?(other_user)
                following.include?(other_user)
              end
            #いいね機能
              def liked_by?(post_id)
                likes.where(post_id: post_id).exists?
              end

    #ログイン ログアウト機能
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  

     # ランダムなトークンを返す
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

    # 渡されたトークンがダイジェストと一致したらtrueを返す
    def authenticated?(attribute, token)
      digest = send("#{attribute}_digest")
      return false if digest.nil?
      BCrypt::Password.new(digest).is_password?(token)
    end

     # ユーザーの記憶ダイジェストを破棄する
    def forget
      update_attribute(:remember_digest, nil)
    end

     # アカウントを有効にする
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # 有効化用のメールを送信する
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end
  
  # パスワード再設定の属性を設定する
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # パスワード再設定のメールを送信する
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # パスワード再設定の有効期限が切れている場合はtrueを返す
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

    private
     # メールアドレスを全て小文字にする
     def downcase_email
      self.email = email.downcase
    end

    # 有効化トークンとダイジェストを作成及び代入する
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    # ランダムなユーザーIDを生成
    def set_user_id
      while self.id.blank? || User.exists?(id: self.id) do
        self.id = SecureRandom.base58
      end
    end
   
  end
  