class InvitationsController < Devise::InvitationsController

  def new
    #might need this to connect wiki
  end
  def create
    #needs user id
    #needs wiki id
    # possibly invitation token, that would need to know about wiki and user
  end
end
