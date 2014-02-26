require 'spec_helper'

describe Relationship do
  it { should validate_uniqueness_of(:follower_id).scoped_to(:leader_id) }
end
