class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.integer :room_id, null: false
      t.string :name, null: false
      t.string :privacy, limit: 16, null: false
      t.boolean :archived, null: false

      t.timestamps null: false
    end

    add_index :rooms, :room_id, unique: true
  end
end
