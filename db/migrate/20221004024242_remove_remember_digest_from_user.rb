class RemoveRememberDigestFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :remember_digest, :string
  end
end
