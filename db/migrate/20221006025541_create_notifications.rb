class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.integer :recipient_id
      t.integer :actor_id
      t.references :notificationable, polymorphic: true, null: false
      t.datetime :read_at
      t.string :action

      t.timestamps
    end
  end
end
