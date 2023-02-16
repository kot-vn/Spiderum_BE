class AddVoteActionToVotes < ActiveRecord::Migration[7.0]
  def change
    add_column :votes, :vote_action, :string, presence: true
  end
end
