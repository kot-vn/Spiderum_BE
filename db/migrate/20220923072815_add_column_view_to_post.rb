class AddColumnViewToPost < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :view, :integer
  end
end
