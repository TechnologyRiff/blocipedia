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
