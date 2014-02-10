Fabricator(:video) do
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
  category { Fabricate(:category) }
end

Fabricator(:category) do
  name { Faker::Lorem.words(2).join(" ") }
end
