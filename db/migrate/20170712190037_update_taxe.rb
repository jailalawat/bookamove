class UpdateTaxe < ActiveRecord::Migration[5.0]
  def change
    add_column :taxes, :account_id, :integer
    remove_column :taxes, :province

    add_index :taxes, :account_id
  end
end
