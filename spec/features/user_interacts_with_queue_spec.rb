# then go the the my_queue page and reorder the videos, for example positions 4, 3, 5
# then press update instant queue, and verify they come back in the correct order

# tricky parts
# when you are on the home page, there is no anchor text, they are just images, make sure to find a way in capybara to find a way to click on the image you want.

require 'spec_helper'

feature 'User interacts with the queue' do
  scenario "user adds and reorders videos in the queue" do
    comedies = Fabricate(:category)
    monk = Fabricate(:video, title: "Monk", category: comedies)
    futurama = Fabricate(:video, title: "Futurama", category: comedies)
    south_park = Fabricate(:video, title: "South Park", category: comedies)
    sign_in
    find("a[href='/videos/#{monk.id}']").click
    page.should have_content(monk.title)
    click_link("+ My Queue")
    page.should have_content(monk.title)
    click_link(monk.title)
    page.should have_content(monk.title)
    page.should_not have_content("+ My Queue")
    visit root_path

    find("a[href='/videos/#{futurama.id}']").click
    page.should have_content(futurama.title)
    click_link("+ My Queue")
    page.should have_content(futurama.title)
    visit root_path

    find("a[href='/videos/#{south_park.id}']").click
    page.should have_content(south_park.title)
    click_link("+ My Queue")
    page.should have_content(south_park.title)

    # find()



  end
end







