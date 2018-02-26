class DropConsumer < ActiveRecord::Migration
  def change
    drop_table :producers
    drop_table :consumers
    
    create_table :clients do |t|
      t.timestamps
    end
  end
end
