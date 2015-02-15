class Wiki < ActiveRecord::Base
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :collaborations, dependent: :destroy

  #after_update :send_favorite_emails

    scope :visible_to, -> (user) { user ? all : publicly_viewable }

    validates :title, presence: true

  def public?
    !private
  end

  def favorited(wiki)
    favorites.where(wiki_id: wiki.id).first
  end

  def favorite?
    wiki.favorited
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
      
      scope :publicly_viewable, -> { where(private: false) }
      scope :privately_viewable, -> { where(private: true) }
end
