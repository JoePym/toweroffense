class Player < ActiveRecord::Base
  has_many :deck_cards
  has_many :cards, :through => :deck_cards
  has_many :squares
end
