Fabricator(:invitation) do
  inviter_id { Fabricate(:user).id }
  recipient_name { Faker::Name.name }
  recipient_email { Faker::Internet.email }
  message { Faker::Lorem.paragraph(2) }
  # token { Faker::Lorem.words(1).first }
end
