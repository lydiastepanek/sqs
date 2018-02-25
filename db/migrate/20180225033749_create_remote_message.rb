class CreateRemoteMessage < ActiveRecord::Migration
  def change
    add_column :messages, :payload, :string

    create_table :remote_messages do |t|
      t.string :payload
      t.timestamps
    end
  end
end
