require 'spec_helper'

feature 'Administrator adds video' do
  scenario "Admin successfully adds a video" do
    alice = Fabricate(:admin)
    dramas = Fabricate(:category, name: "Dramas")
    sign_in(alice)

    visit new_admin_video_path
    fill_in "Title", with: "Monk"
    select('Dramas', :from => 'Category')
    fill_in "Description", with: "Comedy about detective."
    attach_file('Large Cover', 'spec/support/uploads/monk_large.jpg')
    attach_file('Small Cover', 'spec/support/uploads/monk.jpg')
    fill_in "Video url", with: 'http://myflix603.s3.amazonaws.com/HW3%20solution.mp4'
    click_button 'Add Video'
    sign_out

    sign_in
    visit video_path(Video.first)
    expect(page).to have_selector("img[src='/uploads/monk_large.jpg']")

    expect(page).to have_selector("a[href='http://myflix603.s3.amazonaws.com/HW3%20solution.mp4']")
  end
end
