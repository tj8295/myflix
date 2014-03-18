require 'spec_helper'

describe UserSignup do
  describe "#signup" do
    context "valid personal info and valid card" do
      let(:customer) { double(:customer, successful?: true, customer_token: 'fsdjiao') }

      before do
        StripeWrapper::Customer.should_receive(:create).and_return(customer)
        ActionMailer::Base.deliveries.clear
      end

      after { ActionMailer::Base.deliveries.clear }


      it "creates a user" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.first.customer_token).to eq('fsdjiao')
      end

      it "stores the customer token from stripe" do
        UserSignup.new(Fabricate.build(:user)).sign_up("some_stripe_token", nil)
        expect(User.count).to eq(1)
      end


      it "creates following relationship so invitation recipient follows inviter" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up('some_stripe_token', invitation.token)
        joe = User.find_by(email: 'joe@example.com')
        expect(alice.follows?(joe)).to eq(true)
      end

      it "creates following relationship so inviter follows invitation recipient" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up('some_token', invitation.token)
        joe = User.find_by(email: 'joe@example.com')
        expect(joe.follows?(alice)).to eq(true)
      end

      it "resets invitation token" do
        alice = Fabricate(:user)
        invitation = Fabricate(:invitation, inviter: alice)
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Doe')).sign_up('some_token', invitation.token)
        expect(invitation.reload.token).to eq(nil)
      end

      it "sends out an email to user with valid inputs" do
       UserSignup.new(Fabricate.build(:user, email: 'joe@example.com')).sign_up('some_token', nil)
        expect(ActionMailer::Base.deliveries.last.to).to eq(["joe@example.com"])
      end

      it "sends out email containing user's name with valid inputs" do
       UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', full_name: 'Joe Smith')).sign_up('some_token', nil)
        message = ActionMailer::Base.deliveries.last
        message.body.should include("Joe Smith")
      end
    end

    context "valid personal info and declined card" do
      it "does not create a new user" do
        customer = double(:customer, successful?: false, error_message: "Your card was declined")
        customer.stub(:error_message).and_return('Your charge was declined.')
        StripeWrapper::Customer.stub(:create).and_return(customer)
        UserSignup.new(Fabricate.build(:user, email: 'joe@example.com', password: 'password', full_name: 'Joe Smith')).sign_up('some_token', nil)
        expect(User.count).to eq(0)
      end
    end

    context "with invalid user input" do
      after { ActionMailer::Base.deliveries.clear }

      it "does not create a user" do
        UserSignup.new(User.new(email: 'joe@example.com')).sign_up('1234', nil)
        expect(User.count).to eq(0)
      end

      it "does not send email with invalid inputs" do
        UserSignup.new(User.new(email: 'joe@example.com')).sign_up('1234', nil)
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "does not charge the credit card" do
        StripeWrapper::Customer.should_not_receive(:create)
        UserSignup.new(User.new(email: 'joe@example.com')).sign_up('1234', nil)
      end
    end
  end
end
