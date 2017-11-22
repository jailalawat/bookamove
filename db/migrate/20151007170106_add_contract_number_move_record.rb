class AddContractNumberMoveRecord < ActiveRecord::Migration
  def change
    add_column :move_records, :move_contract_number, :string
    add_column :move_records, :move_contract_name, :string
  end
end
