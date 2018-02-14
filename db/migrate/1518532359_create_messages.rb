class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer :room_id, null: false
      t.string :uuid, limit: 36, null: false
      t.string :sender_mention_name, null: false
      t.string :sender_name, null: false
      t.text :body, null: false
      t.datetime :sent_at, null: false

      t.timestamps null: false
    end

    add_index :messages, :uuid, unique: true
    add_index :messages, :sent_at
  end
end
