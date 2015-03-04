class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all
    @persons = @users
    @user = current_user
  end
  
  def show
    @persons = User.all
    @user = User.find(params[:id])
    @role = @user.role
     @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key],
      description: "Premium Membership - #{current_user.name}",
      amount: Amount.default
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

  def role
    @person = User.find(params[:user_id])
    @person.role.save
    redirect_to request.referer
  end

private

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
 
  def scope
    scope :visible_to, -> (user) { user ? all : where(public: true) }
  end 

end