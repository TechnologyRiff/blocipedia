class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collab_users, -> { uniq }, through: :collaborations, source: :user

  #after_update :send_favorite_emails

    validates :title, presence: true

  scope :private_wikis, -> (user) { where("user_id = ? AND private = ?", user, true) }

  def self.collab_users
    User.joins(:collaborations).where(wiki_id: id)
  end

  def public?
    !private
  end

  def private?
    private
  end
  
  def favorited(user)
    favorites.where(wiki_id: id, user_id: user.id).take
  end

  private

  def send_favorite_emails
    favorites.each do |favorite|
      FavoriteMailer.wiki_updated(favorite.user, wiki, self).deliver
    end
  end
     
end
