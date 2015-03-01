class WelcomeController < ApplicationController
  
  def index
    @wikis = Wiki.all
    #authorize @wiki
  end

  def about
  end

  def contact
  end

end
