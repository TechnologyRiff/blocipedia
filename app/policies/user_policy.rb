class UserPolicy < ApplicationPolicy

  def show?
    user.present? && (record.public? || record.user == user || user.admin?)
  end

end