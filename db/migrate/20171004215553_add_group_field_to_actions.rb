class AddGroupFieldToActions < ActiveRecord::Migration[5.0]
  def change
    add_column :actions, :group, :string, after: :is_admin_section
  end
end
