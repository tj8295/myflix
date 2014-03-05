class Invitation < ActiveRecord::Base
  belongs_to :inviter, foreign_key: 'inviter_id', class_name: 'User'

  validates_presence_of :recipient_name
  validates_presence_of :recipient_email
  validates_presence_of :message
  # validates_presence_of :token

  before_create :generate_token

  def generate_token
    self.token = SecureRandom.urlsafe_base64
  end

end

