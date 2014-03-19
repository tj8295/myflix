require 'spec_helper'

feature "User invites friend" do
  scenario "User successfully invites friend and invitation is accepted", { js: true, vcr: true } do
    # joe = User.create(email: "joe@example.com", password: "ok", full_name: "Thomas H", admin: false)
    joe = Fabricate(:user)
    sign_in(joe)
    invite_friend
    friend_accepts_invitation
    friend_signs_in
    friend_should_follow(joe)

    inviter_should_follow_friend(joe)

    clear_emails
  end


  def invite_friend
    visit new_invitation_path
    fill_in "Friend's Name", with: "Alice"
    fill_in "Friend's Email Address", with: "alice@example.com"
    fill_in "Invitation Message", with: "Join now."
    click_button "Send Invitation"
    sign_out
  end

  def friend_accepts_invitation
    sleep 0.1
    open_email("alice@example.com")
    sleep 0.1
    current_email.click_link("Accept invitation")
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: 'password'
    fill_in "Full Name", with: 'Alice'
    fill_in "Credit Card Number", with: "4242 4242 4242 4242"
    fill_in "Security Code", with: "234"
    select('3 - March', :from => 'date_month')
    select('2015', :from => 'date_year')
    click_button "Sign up"
    sleep 0.1
    expect(page).to have_content("Thank you for registering with Myflix.")
  end

  def friend_signs_in
    visit sign_in_path
    fill_in "Email Address", with: "john@example.com"
    fill_in "Password", with: 'password'
    click_button "Sign in"
  end

  def friend_should_follow(user)
    visit people_path
    expect(page).to have_content(user.full_name)
    sign_out
  end

  def inviter_should_follow_friend(inviter)
    sign_in(inviter)
    visit people_path
    expect(page).to have_content("Alice")
  end
end

