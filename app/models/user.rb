class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
after_initialize :init

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :wikis, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :collaborations, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  def init
    self.role ||= 'standard' if self.has_attribute? :role
  end

  def admin?
    role == 'admin'
  end

  def premium?
    role == 'premium'
  end

  def standard?
    role == 'standard'
  end

  def not_standard?
    role == 'premium' || role == 'admin'
  end

  def admin(user)
    if user.role == 'admin'
      user
    end
  end

  def premium(user)
    if user.role == 'premium'
      user
    end
  end

  def standard(user)
    if user.role == 'standard'
      user
    end
  end

  def downgrade
    self.role = 'standard'
    self.save
  end

  def upgrade
    self.role = 'premium'
    self.save
  end

  def make_admin
    self.role = 'admin'
    self.save
  end

  def follow(user)
    follow.where(user_id: user.id).first
  end

  def favorited_wikis
k    favorites = Favorite.where(user_id: @user.id)
    favorited_wikis = Wiki.where(id: favorites.pluck(:wiki_id))
    authorize @wiki
  end
  
  def favorited(user, wiki)
    favorites.where(user_id: user.id, wiki_id: wiki.id).first
  end

  def self.most_followed
    self.select('users.*')
      .select('COUNT(DISTINCT follow.id) AS rank')
      .group('users.id')
      .order('rank DESC')
  end

  def self.search(search)
    where('name like ?', "%#{search}%")
  end

  def self.top_writers
    self.select('users.*')
      .select('COUNT(DISTINCT wikis.id) AS rank')
      .group('users.id')
      .order('rank DESC')
  end

end
