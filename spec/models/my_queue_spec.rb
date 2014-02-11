require 'spec/helper'

describe My_Queue do
  it { should have_many(:videos) }
end
