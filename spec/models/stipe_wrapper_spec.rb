require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    before do
      Stripe.api_key = ENV["STRIPE_SECRET_KEY"]
    end

    let(:token) do
      Stripe::Token.create(
        :card => {
          :number => card_number,
          :exp_month => 3,
          :exp_year => 2015,
          :cvc => "314"
        }
      ).id
    end

    describe ".create" do
      context "with valid card" do
        let(:card_number) { '4242 4242 4242 4242'}

        it "charges the card successfully", :vcr do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          response.should be_successful

        end
      end
    end

    context "with invalid card", :vcr do
      let(:card_number) { '4000000000000002' }
      let(:charge) { StripeWrapper::Charge.create(amount: 999, card: token) }

      it "does not charge successfully" do
        charge.should_not be_successful
      end

      it "returns error message", :vcr do
        charge.error_message.should == "Your card was declined."
      end
    end
  end
end
