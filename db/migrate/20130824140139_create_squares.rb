class CreateSquares < ActiveRecord::Migration
  def change
    create_table :squares do |t|
      t.integer :x
      t.integer :y
      t.integer :index
      t.integer :player_id
      t.timestamps
    end
  end
end
