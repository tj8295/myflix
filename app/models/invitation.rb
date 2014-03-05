require_relative '../../lib/tokenable'

class Invitation < ActiveRecord::Base
  include Tokenable

  belongs_to :inviter, foreign_key: 'inviter_id', class_name: 'User'

  validates_presence_of :recipient_name
  validates_presence_of :recipient_email
  validates_presence_of :message
  # validates_presence_of :token


end

