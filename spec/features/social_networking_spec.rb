require 'spec_helper'

feature 'User tests social networking features' do
  scenario "follows and unfollows someone" do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    jim = User.create(email: "123@gmail.com", password: "123", full_name: "Jim Allen")
    Fabricate(:review, user: jim, video: monk)

    sign_in

    click_on_video_on_homepage(monk)
    click_link jim.full_name
    click_link("Follow")
    expect(page).to have_content(jim.full_name)
    find("a[data-method='delete']").click
    expect(page).not_to have_content(jim.full_name)
  end

  def unfollow(user)
    find("a[data-method='delete']").click
  end
end


# click on people link and then the person you followed should be in the list
# click on unfollow and make sure the person is not in the list
