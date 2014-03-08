Fabricator(:video) do
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(2) }
  category { Fabricate(:category) }
  small_cover { 'monk.jpg' }
  large_cover { "monk_large.jpg" }
end
