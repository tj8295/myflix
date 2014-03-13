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
        response = Stripe::Charge.create(amount: options[:amount], currency: "usd", card: options[:card])
        # new(response, :success)
        new(response: response)
      rescue Stripe::CardError => e
        # new(e, :error)
        new(error_message: e.message)
      end
    end

    def successful?
      # status == :success
      response.present?
    end


  end

  # def self.set_api_key
  #   Stripe.api_key = Rails.env.production? ? ENV['STRIPE_LIVE_API_KEY'] : 'sk_test_S7SfOyW1ciRq6DBVsEb7WPRW'
  # end
end
