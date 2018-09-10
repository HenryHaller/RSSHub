# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts 'deleting all users, shows and episodes'
User.destroy_all
Show.destroy_all
Episode.destroy_all


puts 'creating one user'
henry = User.new(
  email: "henry@gmail.com",
  password: "123456"
  )
puts henry.errors.messages unless henry.save

puts 'creating one show'
cth = Show.new(
  rss_url: 'http://feeds.soundcloud.com/users/soundcloud:users:211911700/sounds.rss'
  )
puts cth.errors.messages unless cth.save

puts 'assigning the show to the user'
henry.shows << cth
puts henry.errors.messages unless henry.save

puts 'creating one episode'
ep = Episode.new(
  title: "this is the test episode",
  show: cth
  )

puts ep.errors.messages unless ep.save
