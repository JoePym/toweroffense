# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:

require 'csv'
Player.create! unless Player.first

Card.destroy_all
Card.create!(rating: 50, width: 0, cost:30, range: 0, card_type: 'shield', name: "Minor Shield", image: 'shieldsmall.png')
Card.create!(rating: 100, width: 0, cost:60, range: 0, card_type: 'shield', name: "Shield", image: 'shield.png')

Card.create!(rating: 400, width: 0, cost:0, range: 0, card_type: 'shield', name: "Titan", :legendary => true)

Card.create!(rating: 15, width: 0, cost: 15, range: 0, card_type: 'heal', name: 'Minor Heal', image: 'heal.png')
Card.create!(rating: 30, width: 0, cost: 30, range: 0, card_type: 'heal', name: 'Heal', image: 'bigheal.png')

Card.create!(rating: 1, width: 50, cost: 0, range: 100, card_type: 'slow', name: 'Entanglement', :legendary => true)

Card.create!(rating: 100, width: 0, cost: 0, range: 0, :card_type => "heal", name: "Nuture", :legendary => true)

Card.create!(rating: 3, width: 0, cost: 0, range: 0, :card_type => "speed", name: "Speed", :legendary => true)
Card.create!(rating: 5, width: 100, cost: 0, range: 100, :card_type => "damage", name: "Earthquake", :legendary => true)
Card.create!(rating: 20, width: 5, cost: 0, range: 0, :card_type => "blast", name: "Cold Spray", :legendary => true)
Card.create!(rating: 60, width: 1, cost: 0, range: 5, :card_type => "damage", name: "Odin's Call", :legendary => true)
Card.create!(rating: 200, width: 0, cost: 0, range: 0, :card_type => "blast", name: "Nightmare", :legendary => true)
Card.create!(rating: 10, width: 0, cost: 0, range: 10, :card_type => "move", name: "Displacement", :legendary => true)
Card.create!(rating: 2, width: 10, cost: 0, range: 100, :card_type => "slow", name: "Slow", :legendary => true)

Card.create!(rating: 1, width: 0, cost: 5, range: 8, card_type: 'damage', name: 'Magic Missile', image: 'arrow.png')
Card.create!(rating: 2, width: 0, cost: 40, range: 4, card_type: 'line', name: 'Lightning bolt', image: 'bolt.png')
Card.create!(rating: 4, width: 1, cost: 80, range: 4, card_type: 'blast', name: 'Fireball', image: 'fireball.png')

Square.destroy_all
data = CSV.read(Rails.root.join('db', 'map.csv'))
index = 0
y = 0
x = 0
dir = data[y][x]
while dir != 'e'
  index +=1
  Player.first.squares.create(:index => index, :y => y + 1, :x => x + 1)
  raise "Oops" if dir == "0"
  case dir
  when "r"
    x += 1
  when "d"
    y += 1
  when "u"
    y -= 1
  when "l"
    x -= 1
  end
  dir = data[y][x]
end

Monster.destroy_all
Monster.create(:name => "Goblin", :hp => 1, :damage => 10, :move => 4, :difficulty => 1)
Monster.create(:name => "Orc", :hp => 2, :damage => 20, :move => 3, :difficulty => 1)
Monster.create(:name => "Troll", :hp => 10, :damage => 25, :move => 2, :difficulty => 2)
Monster.create(:name => "Balrog", :hp => 50, :damage => 80, :move => 1, :difficulty => 10)


Player.first.cards << Card.all