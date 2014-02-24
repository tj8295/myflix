require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }

  describe "#video_title" do
    it "it returns the title of the associated video" do
      friends = Fabricate(:video, title: "Monk")
      queue_item1 = Fabricate(:queue_item, video: friends)
      expect(queue_item1.video_title).to eq('Monk')
    end
  end

  describe "#rating" do
    it "returns the rating from the review when the review is present" do
        alice = Fabricate(:user)
        friends = Fabricate(:video)
        review = Fabricate(:review, user: alice, video: friends)
        queue_item1 = Fabricate(:queue_item, user: alice, video: friends)
        expect(queue_item1.rating).to eq(review.rating)
    end

    it "returns nil if there is no current review" do
        alice = Fabricate(:user)
        friends = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, user: alice, video: friends)
        expect(queue_item1.rating).to be_nil
    end
  end

  describe "rating=" do
    it "updates queue_item's videos rating if review present" do
        alice = Fabricate(:user)
        friends = Fabricate(:video)
        review = Fabricate(:review, user: alice, video: friends, rating: 2)
        queue_item1 = Fabricate(:queue_item, user: alice, video: friends)
        queue_item1.rating = 5
        expect(Review.first.rating).to eq(5)
    end

    it "clears the rating of the review if the review is present" do
        alice = Fabricate(:user)
        friends = Fabricate(:video)
        review = Fabricate(:review, user: alice, video: friends, rating: 2)
        queue_item1 = Fabricate(:queue_item, user: alice, video: friends)
        queue_item1.rating = nil
        expect(Review.first.rating).to be_nil
    end


    it "creates a review if there is none and assigns the rating" do
        alice = Fabricate(:user)
        friends = Fabricate(:video)
        # review = Fabricate(:review, user: alice, video: friends)
        queue_item1 = Fabricate(:queue_item, user: alice, video: friends)
        queue_item1.rating=5
        expect(Review.first.rating).to eq(5)
    end
  end

  describe "#category_name" do
    it "returns genre (category) for the movie" do
        # alice = Fabricate(:user)
        friends = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: friends)
        expect(queue_item1.category_name).to eq(friends.category.name)
    end
  end

  describe "#category" do
    it "returns the cateory of the video" do
        friends = Fabricate(:video)
        queue_item1 = Fabricate(:queue_item, video: friends)
        expect(queue_item1.category).to eq(friends.category)
    end
  end
end
