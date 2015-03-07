class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collab_users, -> { uniq }, through: :collaborations, source: :user

  #after_update :send_favorite_emails

    validates :title, presence: true

  scope :private_wikis, -> (user) { where("user_id = ? AND private = ?", user, true) }


  def public?
    !private
  end

  def private?
    private
  end

  def collaborations
    Wiki.where(wiki_id: id)
  end

  def collab_user
    collaborations.users
  end

  def self.include?(user)
    Wiki.where(user_id: current_user.id) || collaborations.wikis.where(wiki_id: id, user_id: user.id)
  end
  
  def favorited(user)
    favorites.where(wiki_id: id, user_id: user.id).take
  end

  def self.popular
    self.select('wikis.*')
      .select('COUNT(DISTINCT favorites.id) AS rank')
      .group('wiki.id')
      .order('rank DESC')
      .take(5)
  end

  private

  def send_favorite_emails
    wiki.favorites.each do |favorite|
      FavoriteMailer.wiki_updated(favorite.user, wiki, self).deliver
    end
  end
     
end
