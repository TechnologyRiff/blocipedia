class WelcomeController < ApplicationController
  
  def index
    @wikis = Wiki.all
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
