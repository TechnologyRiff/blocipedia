class WikisController < ApplicationController
  before_action :authenticate_user!, :except => [:index]
  require 'will_paginate/array'

  def index
    @wikis = policy_scope(Wiki)
  end

  def auth
    @wiki = Wiki.find(params[:id])
    if @wiki.private?
      @wiki.private = false
    else
      @wiki.private = true
    end
    @wiki.save
    redirect_to request.referer
  end

  def show
    @wiki = Wiki.find(params[:id])
    @user = current_user
    authorize @wiki
  end

  def new
    @wiki = Wiki.new
    authorize @wiki
  end

  def create
    @wiki = Wiki.new(wiki_params)
    @wiki.user = current_user
    authorize @wiki
    if @wiki.save
      flash[:notice] = "Wiki was saved."
      redirect_to request.referer
    else 
      flash[:error] = "There was an error saving the post. Please try again."
      redirect_to :back
    end
  end

  def update
    @wiki = Wiki.find(params[:id])
    authorize @wiki

    if @wiki.update_attributes(wiki_params)
      flash[:notice] = "Wiki was updated."
      redirect_to request.referer
    else
      flash[:error] = "There was an error saving the wiki. Please try again."
      redirect_to :back
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
        redirect_to request.referer
      else
        flash[:error] = "Wiki couldn't be deleted. Try again later."
        redirect_to :back
      end
    end

  private

  def wiki_params
    params.require(:wiki).permit(:title, :body, :private, :image)
  end
end
