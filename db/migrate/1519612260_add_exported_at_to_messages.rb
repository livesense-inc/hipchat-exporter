class AddExportedAtToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :exported_at, :datetime
    add_index :messages, [:exported_at, :sent_at]

    remove_index :messages, :sent_at
  end
end
