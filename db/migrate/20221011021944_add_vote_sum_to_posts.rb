class AddVoteSumToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :vote_sum, :integer, default: 0
  end
end
