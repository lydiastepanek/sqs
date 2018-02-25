class AddReadAtToTablename < ActiveRecord::Migration
  def change
    add_column :messages, :read_at, :datetime
    add_column :messages, :being_read, :boolean
    drop_table :remote_messages
  end
end
