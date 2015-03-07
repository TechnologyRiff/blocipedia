class WelcomeController < ApplicationController
  
  def index
    @wikis = Wiki.all
    @public_wikis = Wiki.where(private: false).paginate(page: params[:page], per_page: 10)
    #authorize @wiki
    if current_user
      @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key],
      description: "Premium Membership - #{current_user.name}",
      amount: Amount.default
      }
    end
  end

  def about
  end

  def contact
  end

end
