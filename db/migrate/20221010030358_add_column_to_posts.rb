class AddColumnToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :favourite_count, :integer, default: 0
    add_column :posts, :month, :integer
    add_column :posts, :year, :integer
  end
end
