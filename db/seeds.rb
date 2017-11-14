Message.destroy_all
User.destroy_all

p "create admin user"
admin = User.create!(
  first_name: 'Martin',
  last_name: 'Furkad',
  role: Role.find_by_code('admin'),
  email: 'admin@example.com',
  password: 'password',
  password_confirmation: 'password'
)
admin.create_access_table(permissions: {})

p "create regular users"
user_service = Services::Users.new

svendsen = user_service.create(
  first_name: 'Emil',
  last_name: 'Svendsen',
  email: 'user@example.com',
  password: 'password',
  password_confirmation: 'password'
)

raise "User is not valid" if !svendsen.valid?

at = svendsen.access_table
at.permissions = {
  news:     [:read],
  surveys:  [:read],
  messages: [:read]
}
at.save

names = %w[
Albert Beutler
Neal Kiser
Anthony Brost
Fredric Laning
Davis Trainor
Tyson Defalco
Stevie Novy
Cletus Cogburn
Leigh Orellana
Nicolas Grandstaff
Cecil Mccormick
Clinton Matthes
Domingo Bea
Wilton Ferrier
Morton Nebel
Edgar Mcgaugh
Zack Holzworth
Omar Quach
Kelly Wragg
Granville Clayborne
Nolan Lesher
Caleb Keller
Heath Caverly
Lesley Giddings
Rodolfo Goad
Adalberto Seale
Jermaine Ridder
Lenny Forcier
Franklyn Ladson
Antony Hoch
]

names.in_groups_of(2) do |group|
  user_service.create(
    first_name: group.first,
    last_name: group.second,
    email: "#{group.first.downcase}@example.com",
    password: 'qwerty',
    password_confirmation: 'qwerty'
  )
end

User.update_all(is_active: true)

require_relative "seeds/messages"
require_relative "seeds/news_entries"