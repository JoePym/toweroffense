class MonsterSerializer < ActiveModel::Serializer
  attributes :id, :name, :hp, :damage, :move, :difficulty
end
