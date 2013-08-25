class PlayerSerializer < ActiveModel::Serializer
  attributes :id
  has_many :cards, :squares, :monsters

  def monsters
    Monster.all
  end

end
