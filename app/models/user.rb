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
  has_many :collab_users, -> { uniq }, through: :collaborations, source: :user
  has_many :collaboration_wikis, -> { uniq }, through: :collaborations, source: :wiki

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

  def collab_wiki
    collaborations.wikis
  end

  def public?
    public == 'true'
  end

  def follow(person)
    follow.where(user_id: person.id).take
  end
  
  def favorited(wiki)
    favorites.where(user_id: id, wiki_id: wiki.id).take
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
