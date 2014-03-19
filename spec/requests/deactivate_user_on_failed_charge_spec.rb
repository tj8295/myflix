require 'spec_helper'

describe "Deactivate user on failed charge" do
  let(:event_data) do
            {
      "id" =>  "evt_103hCJ2rBLgVVd2B789CIt9u",
      "created" =>  1395251776,
      "livemode" =>  false,
      "type" =>  "charge.failed",
      "data" =>  {
        "object" =>  {
          "id" =>  "ch_103hCJ2rBLgVVd2BYWPL2Vkj",
          "object" =>  "charge",
          "created" =>  1395251776,
          "livemode" =>  false,
          "paid" =>  false,
          "amount" =>  999,
          "currency" =>  "usd",
          "refunded" =>  false,
          "card" =>  {
            "id" =>  "card_103hCI2rBLgVVd2B73cybvqk",
            "object" =>  "card",
            "last4" =>  "0341",
            "type" =>  "Visa",
            "exp_month" =>  3,
            "exp_year" =>  2015,
            "fingerprint" =>  "JSWkMcrTia9oRphG",
            "customer" =>  "cus_3gsRIWWuPGLpvg",
            "country" =>  "US",
            "name" =>  nil,
            "address_line1" =>  nil,
            "address_line2" =>  nil,
            "address_city" =>  nil,
            "address_state" =>  nil,
            "address_zip" =>  nil,
            "address_country" =>  nil,
            "cvc_check" =>  "pass",
            "address_line1_check" =>  nil,
            "address_zip_check" =>  nil
          },
          "captured" =>  false,
          "refunds" =>  [],
          "balance_transaction" =>  nil,
          "failure_message" =>  "Your card was declined.",
          "failure_code" =>  "card_declined",
          "amount_refunded" =>  0,
          "customer" =>  "cus_3gsRIWWuPGLpvg",
          "invoice" =>  nil,
          "description" =>  "payment to fail",
          "dispute" =>  nil,
          "metadata" =>  {},
          "statement_description" =>  nil
        }
      },
      "object" =>  "event",
      "pending_webhooks" =>  2,
      "request" =>  "iar_3hCJVohQgIEy6H"
    }
  end

  it "Deactivate user with the web hook data from stripe for charge failed", :vcr do
    jim = Fabricate(:user, customer_token: "cus_3gsRIWWuPGLpvg")
    post "/stripe_events", event_data
    expect(jim.reload).not_to be_active
  end
end
