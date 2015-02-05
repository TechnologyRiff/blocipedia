class WikisController < ApplicationController
  def index
    @wikis = policy_scope(Wiki).paginate(page: params[:page], per_page: 10)
   # authorize @wikis
  end

  def show
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    authorize @wiki
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to @wiki
    else 
      flash[:error] = "There was an error saving the post. Please try again."
    end
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki was updated."
      redirect_to wikis_path
    else
      flash[:error] = "There was an error saving the wiki. Please try again."
      render :edit
    end
  end

  def edit
    @wiki = Wiki.find(params[:id])
    authorize @wiki
  end

    def destroy
      @wiki = Wiki.find(params[:id])

      if @wiki.destroy
        flash[:alert] = "\"#{@wiki.title}\" was deleted successfully."
        redirect_to wikis_path
      else
        flash[:error] = "Wiki couldn't be deleted. Try again later."
      end
    end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private, :image)
  end
end
