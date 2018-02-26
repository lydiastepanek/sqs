class AddReaderIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :reader_id, :integer
  end
end
