class AddTagToPosts < ActiveRecord::Migration[7.0]
  def change
    add_reference :posts, :tag, null: false, foreign_key: true
  end
end
