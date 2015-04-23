class SubscriptionsController < ApplicationController

  def new
    @amount = 15_00
    @stripe_btn_data = {
      key: "#{ Rails.configuration.stripe[:publishable_key] }",
      description: "BigMoney Membership - #{current_user.name}",
      amount: @amount
    }
  end

  def create
    @amount = 15_00
    
    if current_user.customer_id.nil?
      customer = Stripe::Customer.create(
        email: current_user.email,
        card: params[:stripeToken]
      )
      current_user.customer_id = customer.id
    end

    customer = Stripe::Customer.retrieve(current_user.customer_id)
    return unless customer.subscriptions.data.empty?
    customer.subscriptions.create(plan: 'premium')
    current_user.update_attribute(:role, 'premium')

    flash[:success] = "Your payment has been receieved. Thank you!"
    redirect_to edit_user_registration_path

  rescue Stripe::CardError => e
    current_user.update_attribute(:role, 'standard')
    flash[:error] = e.message
    redirect_to new_subscriptions_path
  end

  def downgrade
    customer = Stripe::Customer.retrieve(current_user.customer_id)

    subscription_id = customer.subscriptions.data.first.id
    customer.subscriptions.retrieve(subscription_id).delete
    current_user.update_attributes(role: 'standard')
    current_user.make_wikis_public
    redirect_to edit_user_registration_path
  end

end