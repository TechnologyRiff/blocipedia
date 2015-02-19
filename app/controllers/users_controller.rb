class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.top_rated.paginate(page: params[:page], per_page: 10)
  end
  
  def show
    @persons = User.all
    @user = User.find(params[:id])
    @role = @user.role
     @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key],
      description: "Premium Membership - #{current_user.name}",
      amount: 2000
    }
  end

  def update
    if current_user.update_attributes(user_params)
      flash[:notice] = "User information updated"
      redirect_to edit_user_registration_path
    else
      flash[:error] = "Invalid user information"
      redirect_to edit_user_registration_path
    end
  end

  def downgrade
    current_user.downgrade
    redirect_to current_user
  end

private

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
 
end