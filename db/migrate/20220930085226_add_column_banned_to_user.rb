class AddColumnBannedToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :banned, :boolean, default: 0
  end
end
