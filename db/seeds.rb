# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Player.create! unless Player.first
# Shield:
  #   Played on self, sets your shield to that number

  # Heal:
  #   Played on self, heals that much damage

  # Damage:
  #   Played on square, inflicts that much damage on all objects on that square and within width squares either side.

Card.destroy_all
Card.create!(rating: 5, width: 0, cost:25, range: 0, card_type: 'shield', name: "Minor Shield")
Card.create!(rating: 10, width: 0, cost:50, range: 0, card_type: 'shield', name: "Shield")

Card.create!(rating: 100, width: 0, cost:100, range: 0, card_type: 'shield', name: "Titan", :legendary => true)

Card.create!(rating: 15, width: 0, cost: 15, range: 0, card_type: 'heal', name: 'Minor Heal')
Card.create!(rating: 30, width: 0, cost: 30, range: 0, card_type: 'heal', name: 'Heal')

Card.create!(rating: 1, width: 50, cost: 100, range: 100, card_type: 'slow', name: 'Entanglement', :legendary => true)

Card.create!(rating: 10, width: 10, cost: 100, range: 100, :card_type => "damage", name: "Nuture", :legendary => true)

Card.create!(rating: 5, width: 0, cost: 100, range: 0, :card_type => "speed", name: "Speed", :legendary => true)
Card.create!(rating: 5, width: 100, cost: 100, range: 100, :card_type => "damage", name: "Earthquake", :legendary => true)
Card.create!(rating: 20, width: 5, cost: 100, range: 0, :card_type => "damage", name: "Cold Spray", :legendary => true)
Card.create!(rating: 60, width: 1, cost: 100, range: 5, :card_type => "damage", name: "Odin's Call", :legendary => true)
Card.create!(rating: 200, width: 0, cost: 100, range: 0, :card_type => "heal", name: "Nightmare", :legendary => true)
Card.create!(rating: 10, width: 0, cost: 100, range: 10, :card_type => "move", name: "Displacement", :legendary => true)
Card.create!(rating: 2, width: 10, cost: 100, range: 100, :card_type => "slow", name: "Slow", :legendary => true)

Card.create!(rating: 1, width: 0, cost: 16, range: 8, card_type: 'damage', name: 'Magic Missile')
Card.create!(rating: 2, width: 1, cost: 32, range: 4, card_type: 'damage', name: 'Lightning bolt')
Card.create!(rating: 4, width: 2, cost: 64, range: 2, card_type: 'damage', name: 'Fireball')

Square.destroy_all
(1..5).each do |index|
  Player.first.squares.create(:index => index, :y => 4, :x => index)
  Player.first.squares.create(:index => index + 5, :y => index + 4, :x => 5)
end


Player.first.cards << Card.all