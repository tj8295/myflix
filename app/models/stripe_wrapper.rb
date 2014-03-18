module StripeWrapper

  class Charge
    # attr_reader :response, :status
    attr_reader :error_message, :response

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
      # @status = status
    end

    def self.create(options={})
      # StripeWrapper.set_api_key
      begin
        response = Stripe::Charge.create(
          amount: options[:amount],
          currency: "usd",
          card: options[:card])
        new(response: response)
      rescue Stripe::CardError => e
        # new(e, :error)
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end
  end

  class Customer
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})

      # Stripe.api_key = "sk_test_S7SfOyW1ciRq6DBVsEb7WPRW"
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          email: options[:user].email,
          plan: "base"
        )
        new(response: response)
      rescue Stripe::CardError => e
        new(error_message: e.message)
      end
    end

    def successful?
      response.present?
    end

    def customer_token
      response.id
    end
  end

  # def self.set_api_key
  #   Stripe.api_key = Rails.env.production? ? ENV['STRIPE_LIVE_API_KEY'] : 'sk_test_S7SfOyW1ciRq6DBVsEb7WPRW'
  # end
end
