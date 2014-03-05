require 'spec_helper'

describe Relationship do
  it { should validate_uniqueness_of(:follower_id).scoped_to(:leader_id) }

  # describe "#create_bilateral_relationship(leader, follower)" do
  #   it "creates a relationship where follower follows the leader" do
  #     alice = Fabricate(:user)
  #     bob = Fabricate(:user)
  #     Relationship.create_bilateral_relationship(alice, bob)
  #     expect(alice.following_relationships.first.leader).to eq(bob)
  #   end

  #   it "creates a relationship where leader follows follower"
  # end
end
