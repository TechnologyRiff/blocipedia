# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# create collaboration seed to check that collaboration connection to wiki is working
# validate that email is not the creator's email 

#create user administrator
require 'faker'

5.times do
  user = User.new(
    name:     Faker::Name.name,
    email:    Faker::Internet.email,
    password:   Faker::Lorem.characters(10)
    )
  user.skip_confirmation!
  user.save!
end

users = User.all

15.times do 
  Wiki.create!(
    user:         users.sample,
    title:       Faker::Lorem.sentence,
    body:         Faker::Lorem.paragraph
    )
end
wikis = Wiki.all 

admin = User.new(
  name:     'Admin User',
  email:    'admin@example.com',
  password: 'helloworld',
  role:     'admin'
)
admin.skip_confirmation!
admin.save!

premium_user = User.new(
  name:     'Premium',
  email:    'premium@example.com',
  password: 'helloworld',
  role:     'premium'

)
premium_user.skip_confirmation!
premium_user.save!

10.times do 
  Wiki.create!(
    user:         premium_user,
    title:       Faker::Lorem.sentence,
    body:         Faker::Lorem.paragraph
    )
end

standard_user = User.new(
  name:       'standard user',
  email:       'standard@example.com',
  password:     'helloworld'
)
standard_user.skip_confirmation!
standard_user.save!

10.times do
  Wiki.create!(
    user:         standard_user,
    title:        Faker::Lorem.sentence,
    body:         Faker::Lorem.paragraph
    )
end


5.times do 
collab = Collaboration.new(
  user:     users.sample,
  wiki:     premium_user.wikis.sample
)
end

puts "Seed finished"
puts "#{User.count} users created"
puts "#{Wiki.count} wikis created"