class AddPostToFavourites < ActiveRecord::Migration[7.0]
  def change
    add_reference :favourites, :post, null: false, foreign_key: true
  end
end
