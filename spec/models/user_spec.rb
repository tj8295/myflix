require 'spec_helper'

describe User do
  it { should have_many(:queue_items), -> { order('position') } }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name)}

  describe "#queued_video?" do
    it "returns true when the user queues the video" do
      alice = Fabricate(:user)
      south_park = Fabricate(:video)
      queue_item1 = Fabricate(:queue_item, user: alice, video: south_park)
      expect(alice.queued_video?(south_park)).to eq(true)
    end

    it "returns false when the user has not queued video" do
      alice = Fabricate(:user)
      south_park = Fabricate(:video)
      # queue_item1 = Fabricate(:queue_item, user: alice, video: south_park)
      expect(alice.queued_video?(south_park)).to eq(false)
    end
  end
end
