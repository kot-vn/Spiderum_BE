class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :votetable, polymorphic: true, null: false
      t.integer :vote_score, default: 0

      t.timestamps
    end
  end
end
