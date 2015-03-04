class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :collaborations, dependent: :destroy
  has_many :collab_users, through: :collaborations, source: :user

  #after_update :send_favorite_emails

    validates :title, presence: true

  def public?
    !private
  end

  def collaborations
    Wiki.where(wiki_id: id)
  end

  def collab_user
    collaborations.users
  end

  def self.include?(user)
    collaborations.wikis.where(wiki_id: id, user_id: user.id).take
  end
  
  def favorited(user)
    favorites.where(wiki_id: id, user_id: user.id).take
  end

  def favorited_by_user
    favorites = Favorite.where(wiki_id: id)
    favorited_by_user = User.where(id: favorites.pluck(:user_id))
    favorited_by_user
  end

  def self.popular
    self.select('wikis.*')
      .select('COUNT(DISTINCT favorites.id) AS rank')
      .group('wiki.id')
      .order('rank DESC')
  end

  private

  def send_favorite_emails
    wiki.favorites.each do |favorite|
      FavoriteMailer.wiki_updated(favorite.user, wiki, self).deliver
    end
  end
     
end
