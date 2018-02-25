class AddBeingReadToTablename < ActiveRecord::Migration
  def change
    change_column_default :messages, :being_read, false
  end
end
