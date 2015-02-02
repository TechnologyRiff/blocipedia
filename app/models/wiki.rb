class Wiki < ActiveRecord::Base
  belongs_to :user


    scope :visible_to, -> (user) { user ? all : publicly_viewable }

    validates :title, presence: true

    private
      scope :publicly_viewable, -> { where(private: false) }
      scope :privately_viewable, -> { where(private: true) }
end
