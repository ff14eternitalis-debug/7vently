# Nettoyage pour idempotence
Attendance.destroy_all
Event.destroy_all
User.destroy_all

puts "Création des utilisateurs..."

alice = User.create!(
  email: "alice@yopmail.com",
  encrypted_password: "password123",
  first_name: "Alice",
  last_name: "Martin",
  description: "Passionnée de musique et d'art contemporain."
)

bob = User.create!(
  email: "bob@yopmail.com",
  encrypted_password: "password123",
  first_name: "Bob",
  last_name: "Dupont",
  description: "Photographe amateur et grand voyageur."
)

charlie = User.create!(
  email: "charlie@yopmail.com",
  encrypted_password: "password123",
  first_name: "Charlie",
  last_name: "Bernard",
  description: "Fan de cuisine du monde et de randonnée."
)

puts "#{User.count} utilisateurs créés."

puts "Création des événements..."

event1 = Event.create!(
  title: "Concert Jazz au Parc",
  description: "Une soirée exceptionnelle avec les meilleurs jazzmen de la région. Ambiance garantie sous les étoiles !",
  start_date: 2.weeks.from_now,
  duration: 120,
  price: 15,
  location: "Parc de la Tête d'Or, Lyon",
  user: alice
)

event2 = Event.create!(
  title: "Atelier Photo Urbaine",
  description: "Apprenez à capturer l'essence de la ville lors de cette balade photo guidée dans les rues du centre-ville.",
  start_date: 10.days.from_now,
  duration: 180,
  price: 25,
  location: "Place Bellecour, Lyon",
  user: bob
)

event3 = Event.create!(
  title: "Marché des Saveurs du Monde",
  description: "Découvrez des cuisines du monde entier lors de ce marché festif. Plus de 20 stands de nourriture et d'artisanat.",
  start_date: 3.weeks.from_now,
  duration: 300,
  price: 10,
  location: "Halle Tony Garnier, Lyon",
  user: charlie
)

puts "#{Event.count} événements créés."

puts "Création des participations..."

Attendance.create!(user: bob, event: event1)
Attendance.create!(user: charlie, event: event1)
Attendance.create!(user: alice, event: event2)
Attendance.create!(user: charlie, event: event2)
Attendance.create!(user: alice, event: event3)
Attendance.create!(user: bob, event: event3)

puts "#{Attendance.count} participations créées."
puts "Seed terminé !"
