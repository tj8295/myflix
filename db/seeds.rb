# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# Create videos
Video.create(title: "Monk", description: "Detective with a sixth sense", small_cover_url: "monk.jpg", large_cover_url: "monk_large.jpg")
Video.create(title: "Family Guy", description: "Family with a smart baby", small_cover_url: "family_guy.jpg")
Video.create(title: "South Park", description: "Kids from Colorado", small_cover_url: "south_park.jpg")
Video.create(title: "Futurama", description: "A boy and his robot", small_cover_url: "futurama.jpg")

# Create Categories
Category.create(name: "TV Commedies")
Category.create(name: "TV Dramas")
