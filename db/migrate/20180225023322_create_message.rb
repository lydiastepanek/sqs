class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.timestamps
    end
  end
end
