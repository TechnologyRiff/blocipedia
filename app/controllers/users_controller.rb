class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:show]
  
  def index
    @persons = User.all
    @person = User.take
    @public_user = User.where(public: :true)
    @public_users = @public_user.all
    @user = current_user
    @collab_users = current_user.collab_users
    @collaboration_wikis = current_user.collaboration_wikis
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.name}",
      amount: Amount.default
    }
  end
  
  def show
    @public_users = User.all.where(public: :true)
    @user = User.find(params[:id])
    @role = @user.role
     @stripe_btn_data = {
      key: Rails.configuration.stripe[:publishable_key],
      description: "Premium Membership - #{current_user.name}",
      amount: Amount.default
      }
    @wikis = @user.wikis.where(private: :false)
    @favorited_wikis = @user.favorited_wikis.where(private: :false) 
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