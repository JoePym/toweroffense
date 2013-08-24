class CreateDeckCards < ActiveRecord::Migration
  def change
    create_table :deck_cards do |t|
      t.integer :card_id
      t.integer :player_id
      t.timestamps
    end
    add_index :deck_cards, :card_id
    add_index :deck_cards, :player_id
  end
end
