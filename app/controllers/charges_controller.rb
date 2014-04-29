class ChargesController < ApplicationController
	def new
	end

	def create
		# Amount in cents
		@amount = 5000
		@goal = Rails.cache.read("current_goal")

		customer = Stripe::Customer.create(
	    	:email => current_user.email,
	    	:card  => params[:stripeToken]
		)

		charge = Stripe::Charge.create(
			:customer    => customer.id,
			:amount      => @amount,
			:currency    => 'usd'
		)

		@goal.commitment_contract = true
		@goal.customer_id = "#{charge.card.id}"
		@goal.save

	rescue Stripe::CardError => e
		flash[:error] = e.message
		redirect_to charges_path
	end
end