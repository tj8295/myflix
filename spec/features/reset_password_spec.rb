require 'spec_helper'

feature 'User resets password' do
  scenario "User successfully resets the password" do
    clear_emails
    joe = Fabricate(:user, email: 'joe@example.com', password: "old_password" )
    joe.update_column(:token, '12345')

    visit sign_in_path
    click_link "Forgot password"
    fill_in "Email Address", with: 'joe@example.com'
    click_button "Send email"

    open_email('joe@example.com')
    current_email.click_link('Reset password')

    fill_in "password", with: 'password'
    click_button "Reset Password"
    # visit sigin_in_path
    fill_in "Email Address", with: joe.email
    fill_in "Password", with: 'password'
    click_button "Sign in"

    expect(page).to have_content("You are signed in.")
  end
end





# require 'spec_helper'

# feature 'User tests social networking features' do
#   scenario "follows and unfollows someone" do
#     comedies = Fabricate(:category)
#     monk = Fabricate(:video, title: "Monk", category: comedies)
#     jim = User.create(email: "123@gmail.com", password: "123", full_name: "Jim Allen")
#     Fabricate(:review, user: jim, video: monk)

#     sign_in

#     click_on_video_on_homepage(monk)
#     click_link jim.full_name
#     click_link("Follow")
#     expect(page).to have_content(jim.full_name)
#     find("a[data-method='delete']").click
#     expect(page).not_to have_content(jim.full_name)
#   end

#   def unfollow(user)
#     find("a[data-method='delete']").click
#   end
# end
