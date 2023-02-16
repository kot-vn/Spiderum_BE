class AddTimeBanToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :time_ban, :datetime
  end
end
