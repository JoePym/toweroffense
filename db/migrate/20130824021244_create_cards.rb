class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string :name
      t.boolean :legendary, :null => false, :default => false
      t.integer :rating
      t.integer :width
      t.integer :range
      t.integer :cost
      t.string :card_type
      t.string :monster_id
      t.timestamps
    end
  end
end
