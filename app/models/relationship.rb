class Relationship < ActiveRecord::Base
  belongs_to :leader, class_name: "User"
  belongs_to :follower, class_name: "User"
  validates_uniqueness_of :follower_id, scope: [:leader_id]

  def self.create_bilateral_relationship(follower, leader)
    Relationship.create(follower: follower, leader: leader)
    Relationship.create(leader: follower, follower: leader)
  end
end

