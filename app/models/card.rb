class Card < ActiveRecord::Base
  has_many :deck_cards
end
