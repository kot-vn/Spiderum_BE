class AddVoteSumToComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :vote_sum, :integer,default: 0
  end
end
