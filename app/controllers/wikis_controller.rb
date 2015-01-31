class WikisController < ApplicationController
  def index
    @wikis = Wiki.all
  end

  def show
    @wiki = Wiki.find(params[:id])
  end

  def new
    @wiki = Wiki.new
  end

  def create
    @wiki = Wiki.new()
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else 
      flash[:error] = "There was an error saving the post. Please try again."
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
  end

  def update
    @wiki = Wiki.find(params[:id])
    if @wiki.update_attributes
      flash[:notice] = "Wiki was updated."
      redirect_to @wiki
    else
      flash[:error] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  private

  def params_wiki
    params.require(:wiki).permit(:title, :body)
  end
end
