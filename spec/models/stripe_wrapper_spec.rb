require 'spec_helper'

describe StripeWrapper do
  let(:valid_token) do
    Stripe::Token.create(
      :card => {
        :number => '4242 4242 4242 4242',
        :exp_month => 3,
        :exp_year => 2015,
        :cvc => "314"
      }
    ).id
  end

  let(:invalid_token) do
    Stripe::Token.create(
      :card => {
        :number => '4000000000000002',
        :exp_month => 3,
        :exp_year => 2015,
        :cvc => "314"
      }
    ).id
  end

  describe StripeWrapper::Charge do
    describe ".create" do
      context "with valid card" do
        it "charges the card successfully", :vcr do
          response = StripeWrapper::Charge.create(amount: 999, card: valid_token)
          response.should be_successful
          expect(response).to be_successful
          expect(response.successful?).to eq(true)
        end
      end
    end

    context "with invalid card", :vcr do
      let(:charge) { StripeWrapper::Charge.create(
          amount: 999,
           card: invalid_token) }

      it "does not charge successfully" do
        charge.should_not be_successful
      end

      it "returns error message", :vcr do
        charge.error_message.should == "Your card was declined."
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create" do
      context "with valid card", :vcr do
        it "creates a customer with valid card" do
          alice = Fabricate(:user)
          response = StripeWrapper::Customer.create(user: alice, card: valid_token)
          expect(response).to be_successful
        end
      end

      it "does not create subscription with declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(user: alice, card: invalid_token)
        expect(response).not_to be_successful
      end

      it "returns error message with declined card", :vcr do
        alice = Fabricate(:user)
        response = StripeWrapper::Customer.create(user: alice, card: invalid_token)
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end
