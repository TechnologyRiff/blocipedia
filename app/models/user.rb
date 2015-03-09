class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
after_initialize :init

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_many :wikis, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_wikis, through: :favorites, source: :wiki
  has_many :collaborations, dependent: :destroy
  #has_many :collab_users, -> { uniq }, through: :collaborations, source: :user
  has_many :collaboration_wikis, -> { uniq }, through: :collaborations, source: :wiki

  mount_uploader :avatar, AvatarUploader

  # def collab_users
  #   User.joins(:collaborations).where(user_id: id)
  # end

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

  def downgrade
    self.role = 'standard'
    Wiki.where(user_id: id, private: true).destroy_all
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

  def public?
    public == 'true'
  end
  
  def favorited(wiki)
    favorites.where(user_id: id, wiki_id: wiki.id).take
  end

  def self.search(search)
    where('name like ?', "%#{search}%")
  end

end
