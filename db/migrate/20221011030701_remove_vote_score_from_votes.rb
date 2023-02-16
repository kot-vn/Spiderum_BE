class RemoveVoteScoreFromVotes < ActiveRecord::Migration[7.0]
  def change
    remove_column :votes, :vote_score, :integer
  end
end
