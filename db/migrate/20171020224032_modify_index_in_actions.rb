class ModifyIndexInActions < ActiveRecord::Migration[5.0]
  def change
    remove_index :actions, :key
    add_index :actions, :key
  end
end
