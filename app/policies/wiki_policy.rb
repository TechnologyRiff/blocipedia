class WikiPolicy < ApplicationPolicy
  
  def wiki
    record 
  end

  def update?
    user.present?
  end


  class Scope
   attr_reader :user, :scope

  def initialize(user, scope)
    @user = user
    @scope = scope
  end

  def resolve
    wikis = []
    if user.admin?
      wikis = scope.all
    elsif user.premium?
      all_wikis = scope.all
      wikis = []
      all_wikis.each do |wiki|
        if wiki.public? || wiki.user == user #|| wiki.users.include?(user)
          wikis << wiki
        end
      end
    else
      all_wikis = scope.all
      wikis = []
      all_wikis.each do |wiki|
        if wiki.public? #|| wiki.users.include?(user)
          wikis << wiki
        end
      end
    end
    wikis
  end
end

  
end