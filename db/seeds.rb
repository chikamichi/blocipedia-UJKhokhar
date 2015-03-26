require 'faker'

## Create Users
5.times do
  user = User.new(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Lorem.characters(10)
    )
  user.skip_confirmation!
  user.save
end

## Create admin user for testing
umar = User.create!(
  name: 'Umar Khokhar',
  email: 'ujkhokhar@gmail.com',
  password: 'helloworld',
  role: 'admin'
)
umar.skip_confirmation!
umar.save

users = User.all
puts "#{User.count} users created."

## Create wikis
20.times do 
  wiki = Wiki.create!(
    user: users.sample,
    title: Faker::Lorem.sentence,
    body: Faker::Lorem.paragraph
  )
end

wikis = Wiki.all
puts "#{wikis.count} wikis created."