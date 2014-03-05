require 'spec_helper'

describe Invitation do
  it { should belong_to(:inviter) }
  it { should validate_presence_of(:recipient_name) }
  it { should validate_presence_of(:recipient_email) }
  it { should validate_presence_of(:message) }

  describe "#generate_token" do
    it "adds a random token to token field when record created" do
      invitation = Fabricate(:invitation)
      expect(invitation.token).not_to eq(nil)
    end
  end
end

