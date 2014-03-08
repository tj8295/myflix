Fabricator(:video) do
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
  category { Fabricate(:category) }
  small_cover_url { 'monk.jpg' }
  large_cover_url { "monk_large.jpg" }
end
