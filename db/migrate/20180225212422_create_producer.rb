class CreateProducer < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.timestamps
    end
    
    create_table :consumers do |t|
      t.timestamps
    end
  end
end
