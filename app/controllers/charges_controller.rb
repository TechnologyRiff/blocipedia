class ChargesController < ApplicationController
  def create
    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
      )
    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: Amount.default,
      description: "Premium Membership - #{current_user.email}",
      currency: 'usd'
      )

    current_user.role = "premium"
    current_user.save
    flash[:success] = "Thanks for upgrading, #{current_user}!"
    redirect_to user_path(current_user)

  rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path

  end

  def new
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "Premium Membership - #{current_user.name}",
      amount: Amount.default
    }
  end

  def edit
  end
end
