# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Create some users
alice = User.create(
  :name => "Alice",
  :username => "alice",
  :email => "alice@upshift.network",
  :password => "password",
  :confirmed_registration => true
)

bob = User.create(
  :name => "Bob",
  :username => "bob",
  :email => "bob@upshift.network",
  :password => "password",
  :confirmed_registration => true
)

carla = User.create(
  :name => "Carla",
  :username => "carla",
  :email => "carla@upshift.network",
  :password => "password",
  :confirmed_registration => true
)

dennis = User.create(
:name => "Dennis",
:username => "dennis",
:email => "dennis@upshift.network",
:password => "password",
:confirmed_registration => true
)

[alice, bob, carla, dennis].each do |user|
  Profile.create(:user => user)
end

# Create some posts
100.times do |i|
  Post.create(:author => User.order("RANDOM()").first, :content => "Post #{i}\nLorem Ipsum Dolorem")
end

### Democracy

# Create a Community
Democracy::Community.create(name: 'Test Community')
