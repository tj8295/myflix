# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# TODO there is a issue with seeding so that it is creating the categories twice

# Create Categories
comedies = Category.create(name: "TV Commedies")
dramas = Category.create(name: "TV Dramas")

# Create videos
monk = Video.create(title: "Monk", description: "Detective with a sixth sense", small_cover_url: "monk.jpg", large_cover_url: "monk_large.jpg", category: comedies)
family_guy = Video.create(title: "Family Guy", description: "Family with a smart baby", small_cover_url: "family_guy.jpg", category: comedies)
south_park = Video.create(title: "South Park", description: "Kids from Colorado", small_cover_url: "south_park.jpg", category: comedies)
futurama = Video.create(title: "Futurama", description: "A boy and his robot", small_cover_url: "futurama.jpg", category: comedies)

Video.create(title: "Family Guy", description: "Family with a smart baby", small_cover_url: "family_guy.jpg", category: comedies)
Video.create(title: "South Park", description: "Kids from Colorado", small_cover_url: "south_park.jpg", category: comedies)
Video.create(title: "Futurama", description: "A boy and his robot", small_cover_url: "futurama.jpg", category: comedies)
Video.create(title: "Futurama", description: "A boy and his robot", small_cover_url: "futurama.jpg", category: dramas)

tom = User.create(email: "tch399@gmail.com", password: "123", full_name: "Thomas Habif")

jim = User.create(email: "123@gmail.com", password: "123", full_name: "Jim Allen")

bob = User.create(email: "13@gmail.com", password: "12s3", full_name: "Bob Thomas")

Review.create(user: tom, video: monk, rating: 5, content: "this is a good movie!")
Review.create(user: tom, video: monk, rating: 2, content: "Not a great one")
Review.create(user: bob, video: south_park, rating: 2, content: "a very good one")
Review.create(user: bob, video: futurama, rating: 2, content: "a very nice one")
Review.create(user: bob, video: family_guy, rating: 2, content: "a very nice one")
Review.create(user: jim, video: family_guy, rating: 2, content: "a very nice one")



