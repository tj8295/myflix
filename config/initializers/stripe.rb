Stripe.api_key = ENV["STRIPE_SECRET_KEY"]

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    # Define subscriber behavior based on the event object
    # event.class       #=> Stripe::Event
    # event.type        #=> "charge.failed"
    # event.data #=> #<Stripe::Charge:0x3fcb34c115f8>
    user = User.find_by(customer_token: event.data.object.customer)
    Payment.create(user: user)
  end

  events.all do |event|
    # Handle all event types - logging, etc.
  end
end
