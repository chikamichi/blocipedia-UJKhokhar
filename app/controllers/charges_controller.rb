class ChargesController < ApplicationController

  def new
  end

  def create
    @amount = 15_00

    customer = Stripe::Customer.create(
      email: current_user.email,
      card: params[:stripeToken]
    )

    charge = Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: "BigMoney Membership - #{current_user.email}",
      currency: 'usd'
    )

    flash[:success] = "Your payment has been receieved. Thank you!"
    redirect_to user_path(current_user)

    rescue Stripe::CardError => e
      flash[:error] = e.message
      redirect_to new_charge_path
  end

end