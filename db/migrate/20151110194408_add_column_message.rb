class AddColumnMessage < ActiveRecord::Migration
  def change
    change_column :messages, :urgent, :integer, default: 0
  end
end
