require 'spec_helper'

describe "Crete payment on successful charge" do

  let(:event_data) do
    {
    "id" => "evt_103gYE2rBLgVVd2BW36IO9gf",
    "created" => 1395102641,
    "livemode" => false,
    "type" => "charge.succeeded",
    "data" => {
      "object" => {
        "id" => "ch_103gYE2rBLgVVd2BVBN3az5K",
        "object" => "charge",
        "created" => 1395102640,
        "livemode" => false,
        "paid" => true,
        "amount" => 999,
        "currency" => "usd",
        "refunded" => false,
        "card" => {
          "id" => "card_103gYE2rBLgVVd2B4Mho3S0H",
          "object" => "card",
          "last4" => "4242",
          "type" => "Visa",
          "exp_month" => 3,
          "exp_year" => 2015,
          "fingerprint" => "DtFcTOgjqEjUcaMY",
          "customer" => "cus_3gYEgs6f5qNfVo",
          "country" => "US",
          "name" => nil,
          "address_line1" => nil,
          "address_line2" => nil,
          "address_city" => nil,
          "address_state" => nil,
          "address_zip" => nil,
          "address_country" => nil,
          "cvc_check" => "pass",
          "address_line1_check" => nil,
          "address_zip_check" => nil
        },
        "captured" => true,
        "refunds" => [],
        "balance_transaction" => "txn_103gYE2rBLgVVd2B0LfNOCN4",
        "failure_message" => nil,
        "failure_code" => nil,
        "amount_refunded" => 0,
        "customer" => "cus_3gYEgs6f5qNfVo",
        "invoice" => "in_103gYE2rBLgVVd2BvhC9UArD",
        "description" => nil,
        "dispute" => nil,
        "metadata" => {},
        "statement_description" => "Myflix"
      }
    },
    "object" => "event",
    "pending_webhooks" => 1,
    "request" => "iar_3gYEGwxyLT6j5x"
  }
  end

  it "creates a payment with the webook from stripe for charge succeeded", :vcr do

    post "/stripe_events", event_data
    expect(Payment.count).to eq(1)
  end

  it "creates the payment associated with the user", :vcr do
    alice = Fabricate(:user, customer_token: "cus_3gYEgs6f5qNfVo")
    post "/stripe_events", event_data
    expect(Payment.first.user).to eq(alice)
  end
end
