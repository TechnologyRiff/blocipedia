class CollaborationsController < ApplicationController

  def new
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.where(email: params[:email]).take
    if @user 
      collab = Collaboration.new(wiki: @wiki, user: @user)
      if collab.save
        flash[:notice] = "Collaborator was saved."
      else 
        flash[:error] = "There was an error. Please try again."
      end
    else
      # invite by email
      flash[:notice] = "Collaborator was invited."
    end
    redirect_to request.referer
  end
  
  def create
    @wiki = Wiki.find(params[:wiki_id])
    @user = User.where(email: params[:email]).take
    if @user
      collab = Collaboration.new(wiki: @wiki, user: @user)
      if collab.save
        flash[:notice] = "Collaborator was saved."
      else 
        flash[:error] = "There was an error. Please try again."
      end
    else
      # invite by email
      flash[:notice] = "Collaborator was invited."
    end
    redirect_to request.referer
  end

  def delete
    @wiki = Wiki.find(params[:id])
    @user = User.where(email: params[:email]).take
    collab = Collaboration.where(wiki: @wiki, user: @user)
    if collab.destroy
      flash[:alert] = "\"#{@user.name}\" was removed as a collaborator."
      redirect_to @wiki
    else
      flash[:error] = "There was an error. Please try again."
    end
  end

  def search
    @user = User.where(email: params[:email]).take
  end

private

end
