class CardSerializer < ActiveModel::Serializer
  attributes :id, :rating, :width, :cost, :card_type, :legendary, :name, :range
end
