class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
after_initialize :init

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable

  mount_uploader :avatar, AvatarUploader

  def admin?
    role == 'admin'
  end

  def premium?
    role == 'premium'
  end

  def standard?
    role == 'standard'
  end

  def init
    self.role ||= 'standard' if self.has_attribute? :role
  end

  def favorited(user)
    favorites.where(user_id: user.id).first
  end

  def self.top_rated
    self.select('users.*')
      .select('COUNT(DISTINCT wikis.id) AS rank')
      .group('users.id')
      .order('rank DESC')
  end

end
