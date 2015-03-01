class FavoritesController < ApplicationController

  def create
    @wiki = Wiki.find(params[:wiki_id])
    @favorite = current_user.favorites.build(wiki: @wiki)
    authorize @favorite
    if favorite.save
      flash[:notice] = "Favorite added."
      redirect_to @wiki
    else
      flash[:notice] = "Problem creating favorite. Please try again later."
      redirect_to @wiki
    end
  end

  def destroy
    @wiki = Wiki.find(params[:wiki_id])
    @favorite = Favorite.find(params[:id])
    authorize @favorite
    if @favorite.destroy
      flash[:notice] = "Favorite was deleted"
      redirect_to @wiki
    else
      flash[:notice] = "There was an error deleting your favorite. Please try again later."
      redirect_to @wiki
    end
  end
end
