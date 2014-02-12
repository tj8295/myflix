require 'spec_helper'

describe Video do
  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should have_many(:reviews).order("created_at DESC") }
end


describe ".search_by_title" do
  it "returns empty array if there is no match" do
    futurama = Video.create(title: "Futurama", description: "Space Travel!")
    back_to_future = Video.create(title: "Back to Future", description: "Time travel!")
    expect(Video.search_by_title("Big")).to eq([])
  end

  it "returns an array with one video for an exact match" do
    video = Video.create(title: "Big", description: "Tom Hanks becomes a child.")
    expect(Video.search_by_title("Big")).to match_array([video])
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
end #end of search_by_title test

describe ".search_by_title_categorized" do
  it "categorizes the search results" do
    comedies = Category.create(name: "Comedies")
    dramas = Category.create(name: "Dramas")
    westerns = Category.create(name: "Western")
    thriller = Category.create(name: "Thriller")

    friends = comedies.videos.create(title: "Friends", description: "A group of friends")
    big = Video.create(title: "Big Friends", description: "Tom Hanks becomes a child", category: comedies)
    back_to_future = Video.create(title: "Back to Future Friends", description: "Time travel!", category: comedies)
    nypd_blue = Video.create(title: "NYPD Blue Friends", description: "Police drama", category: dramas)
    friends_saloon = westerns.videos.create(title: "Friends Saloon", description: "A nice western")
    cowboy = westerns.videos.create(title: "Cowboy Friends", description: "Nice")
    jackson = thriller.videos.create(title: "M. Jackson", description: "Music video")

    results = Video.search_by_title_categorized("Friends")

    expect(results.videos_for_category(comedies)).to match_array([friends, big, back_to_future])
    expect(results.videos_for_category(westerns)).to match_array([friends_saloon, cowboy])
    expect(results.videos_for_category(dramas)).to match_array([nypd_blue])
  end
end
