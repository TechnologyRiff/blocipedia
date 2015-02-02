class WikiPolicy < ApplicationPolicy
  # attr_reader :wiki, :user

  # def initialize(user, wiki)
  #   @wiki = wiki
  #   @user = user
  # end

  def wiki
    record 
  end

  def update?
    user.present? && wiki.public?

  end
end