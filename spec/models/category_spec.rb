require 'spec_helper'

describe Category do
  it { should have_many(:videos) }
end


describe "recent_videos" do

  it "returns empty array when no videos if category does not have any videos" do
    dramas = Category.create(name: "Dramas")
    expect(dramas.recent_videos).to eq([])
  end

  it "returns the videos in the reverse chronical order by created at" do
    comedies = Category.create(name: "Comedies")

    futurama = Video.create(title: "Futurama", description: "Space Travel!", category: comedies, created_at: 3.days.ago)
    back_to_future = Video.create(title: "Back to Future", description: "Time travel!", category: comedies, created_at: 2.days.ago)
    big = Video.create(title: "Big", description: "Tom Hanks becomes a child.", category: comedies, created_at: 1.day.ago)

    expect(comedies.recent_videos).to eq([big, back_to_future, futurama])
  end

  it "returns array of all videos when less than six" do
    comedies = Category.create(name: "Comedies")

    futurama = Video.create(title: "Futurama", description: "Space Travel!", category: comedies, created_at: 3.days.ago)
    back_to_future = Video.create(title: "Back to Future", description: "Time travel!", category: comedies, created_at: 2.days.ago)
    big = Video.create(title: "Big", description: "Tom Hanks becomes a child.", category: comedies, created_at: 1.day.ago)

    expect(comedies.recent_videos.count).to eq(3)
  end


  it "returns array of six videos when more than six" do
    comedies = Category.create(name: "Comedies")
    7.times do
      Video.create(title: "Futurama", description: "Space Travel!", category: comedies, created_at: 3.days.ago)
    end
    expect(comedies.recent_videos.count).to eq(6)
  end

  it "returns the most recent 6 videos" do
    comedies = Category.create(name: "Comedies")
    6.times do
      Video.create(title: "Futurama", description: "Space Travel!", category: comedies)
    end
    big = Video.create(title: "Big", description: "Tom Hanks becomes a child.", category: comedies, created_at: 1.day.ago)
    expect(comedies.recent_videos).not_to include(big)
  end

end
