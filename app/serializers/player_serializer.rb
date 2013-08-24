class PlayerSerializer < ActiveModel::Serializer
  attributes :id
  has_many :cards, :squares

end
