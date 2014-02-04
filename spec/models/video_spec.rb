require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
end

# //self.search_by_title(search_term)
# Video.search_by_title("family") //pass a string, only learing to title
# can do partial match
#   if none videos found return empty arrya
#     if one or multiple return an array with the videos

#       test not find single video
#       find one
#       find multiple

#       how do search in active record, need LIKE
describe "search_by_title" do
  it "returns empty array if there is no match" do
    futurama = Video.create(title: "Futurama", description: "Space Travel!")
    back_to_future = Video.create(title: "Back to Future", description: "Time travel!")
    expect(Video.search_by_title("Big")).to eq([])
  end

  it "returns an array with one video for an exact match" do
    video = Video.create(title: "Big", description: "Tom Hanks becomes a child.")
    # Video.search_by_title("Big").should eq([video])
    expect(Video.search_by_title("Big")).to eq([video])
  end

  it "returns an array with one video for a partial match" do
    video = Video.create(title: "Big", description: "Tom Hanks becomes a child.")
    expect(Video.search_by_title("Bi")).to eq([video])
  end

  it "returns an array of all matches ordered by created_at" do
    big = Video.create(title: "Big", description: "Tom Hanks becomes a child.", created_at: 1.day.ago)
    bill = Video.create(title: "Bill", description: "The Bill Clinton story.")
    expect(Video.search_by_title("Bi")).to eq([bill, big])
  end

  it "return an empty array if the user search term in an empty string" do
    big = Video.create(title: "Big", description: "Tom Hanks becomes a child.", created_at: 1.day.ago)
    bill = Video.create(title: "Bill", description: "The Bill Clinton story.")
    expect(Video.search_by_title("")).to eq([])
  end

end
