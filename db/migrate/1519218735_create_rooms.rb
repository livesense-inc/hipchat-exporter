class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :name, null: false
      t.string :privacy, limit: 16, null: false
      t.boolean :archived, null: false

      t.timestamps null: false
    end
  end
end
