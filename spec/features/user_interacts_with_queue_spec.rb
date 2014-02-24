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

    add_video_to_queue(monk)
    expect_video_to_be_in_queue(monk)

    visit video_path(monk)
    expect_link_not_to_be_seen("+ My Queue")

    add_video_to_queue(futurama)
    add_video_to_queue(south_park)
    expect_video_to_be_in_queue(futurama)

    set_video_position(monk, 3)
    set_video_position(futurama, 2)
    set_video_position(south_park, 1)


    # within(:xpath, "//tr[contains(.,'#{monk.title}')]") do
    #   fill_in "queue_items[][position]", with: 3
    # end

    # within(:xpath, "//tr[contains(.,'#{futurama.title}')]") do
    #   fill_in "queue_items[][position]", with: 2
    # end

    # within(:xpath, "//tr[contains(.,'#{south_park.title}')]") do
    #   fill_in "queue_items[][position]", with: 1
    # end

    # find("input[data-video-id='#{monk.id}']").set(3)
    # find("input[data-video-id='#{futurama.id}']").set(2)
    # find("input[data-video-id='#{south_park.id}']").set(1)

    # fill_in "video_#{monk.id}", with: 3
    # fill_in "video_#{futurama.id}", with: 2
    # fill_in "video_#{south_park.id}", with: 1
    update_queue
    # expect(find("input[data-video-id='#{south_park.id}']").value).to eq('1')
    # expect(find("input[data-video-id='#{futurama.id}']").value).to eq('2')
    # expect(find("input[data-video-id='#{monk.id}']").value).to eq('3')

    expect_video_position(south_park, 1)
    expect_video_position(futurama, 2)
    expect_video_position(monk, 3)



    # expect(find(:xpath, "//tr[contains(.,'#{south_park.title}')]//input[@type='text']").value).to eq("1")
    # expect(find(:xpath, "//tr[contains(.,'#{futurama.title}')]//input[@type='text']").value).to eq("2")
    # expect(find(:xpath, "//tr[contains(.,'#{monk.title}')]//input[@type='text']").value).to eq("3")

    # expect(find("#video_#{south_park.id}").value).to eq('1')
    # expect(find("#video_#{futurama.id}").value).to eq('2')
    # expect(find("#video_#{monk.id}").value).to eq('3')
  end


  def add_video_to_queue(video)
    visit root_path
    find("a[href='/videos/#{video.id}']").click
    page.should have_content(video.title)
    click_link("+ My Queue")
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end

  def expect_video_to_be_in_queue(video)
    page.should have_content(video.title)
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def expect_link_not_to_be_seen(link_text)
    page.should_not have_content(link_text)
  end
end







