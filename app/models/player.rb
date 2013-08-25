class Player < ActiveRecord::Base
  has_many :deck_cards
  has_many :cards, :through => :deck_cards
  has_many :squares

  def normal_cards
    self.cards.where(:legendary => false)
  end

  def legendary_cards
    self.cards.where(:legendary => true)
  end
end
