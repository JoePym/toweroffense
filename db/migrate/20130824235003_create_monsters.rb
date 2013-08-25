class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.string :name
      t.integer :hp
      t.integer :damage
      t.integer :move
      t.integer :difficulty
      t.timestamps
    end
  end
end
