require 'spec_helper'

feature "user signs up and makes payment", {js: true, vcr: true } do

  background do
        visit register_path
  end

  scenario "valid user information, valid credit card" do
    input_valid_user
    pay_with_credit_card('4242 4242 4242 4242')
    expect(page).to have_content "Thank you for registering with Myflix."
  end

  scenario "valid user, invalid credit card" do
    input_valid_user
    pay_with_credit_card('4000000000000069')
    expect(page).to have_content "Your card's expiration date is incorrect."
  end

  scenario "valid user, credit card declined" do
    input_valid_user
    pay_with_credit_card('4000000000000002')
    expect(page).to have_content "Your card was declined."
  end

  scenario "invalid user information, valid credit card" do
    input_invalid_user
    pay_with_credit_card('4242 4242 4242 4242')
    expect(page).to have_content "Invalid user information. Please see the errors below."
  end

  scenario "invalid user invalid credit card" do
    input_invalid_user
    pay_with_credit_card('4000000000000069')
    expect(page).to have_content "Invalid user information. Please see the errors below."
  end

  scenario "invalid user declined credit card" do
    input_invalid_user
    pay_with_credit_card('4000000000000002')
    expect(page).to have_content "Invalid user information. Please see the errors below."
  end
end

def pay_with_credit_card(credit_card)
    fill_in "Credit Card", with: credit_card
    fill_in "Security Code", with: '234'
    select  "3 - March", from: 'date_month'
    select  "2015", from: 'date_year'
    click_button 'Sign up'
end

def input_valid_user
    fill_in "Email Address", with: 'alice@example.com'
    fill_in "Password", with: 'fdsa'
    fill_in "Full Name", with:'Thomas H'
end

def input_invalid_user
    fill_in "Email Address", with: 'alice@example.com'
    fill_in "Full Name", with:'Thomas H'
end
