class RemoveUniqueEmailUser < ActiveRecord::Migration
  def change
    add_index :users, :account_id
    remove_index :users, column: [:account_id, :email]
  end
end
