class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :square, :default => 0, :null => false
      t.timestamps
    end
  end
end
