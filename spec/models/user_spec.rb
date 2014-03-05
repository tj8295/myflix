require 'spec_helper'

describe User do
  it { should have_many(:queue_items), -> { order('position') } }
  it { should have_many(:invitations) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:full_name)}

  it_behaves_like "tokenable" do
    let(:object) { Fabricate(:user) }
  end

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

  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to eq(true)
    end

    it "does not follow oneself" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to eq(false)
    end
  end

  describe "#follows?" do
    it "returns true if the user has a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Relationship.create(follower: alice, leader: bob)
      expect(alice.follows?(bob)).to eq(true)
    end

    it "returns false if the user does not have a following relationship with another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      expect(alice.follows?(bob)).to eq(false)
    end
  end

  describe ".find_user_by_invitation_token" do
    it "finds and returns a user object given an invitation token" do
      alice = Fabricate(:user)
      invitation = Fabricate(:invitation, inviter: alice)
      expect(User.find_inviter_by_token(invitation.token)).to eq(alice)
    end
  end
end
