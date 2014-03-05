require_relative '../../lib/tokenable'

class User < ActiveRecord::Base
  include Tokenable

  has_many :queue_items, -> { order('position') }
  has_many :reviews
  has_many :following_relationships, class_name: "Relationship", foreign_key: :follower_id
  has_many :leading_relationships, class_name: "Relationship", foreign_key: :leader_id
  has_many :invitations, class_name: "Invitation", foreign_key: "inviter_id"

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :full_name, presence: true

  has_secure_password validations: false


  def normalize_queue_item_positions
    queue_items.each_with_index do |queue_item, index|
      queue_item.update_attributes(position: index + 1)
    end
  end

  def queued_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def follow(another_user)
    following_relationships.create(leader: another_user) if can_follow?(another_user)
  end

  def follows?(another_user)
    following_relationships.map(&:leader).include?(another_user)
  end

  def can_follow?(another_user)
    !(self.follows?(another_user) || self == another_user)
  end

  def self.find_inviter_by_token(token)
    inviter_id = Invitation.find_by(token: token).inviter_id
    User.find(inviter_id)
  end
end


