class CreateSubjectSuggestions < ActiveRecord::Migration
  def change
    create_table :subject_suggestions do |t|
      t.string :description
      t.boolean :active, default: true
      t.integer :account_id
      t.foreign_key :accounts
      t.timestamps
    end
    add_index :subject_suggestions, :description
    add_index :subject_suggestions, :account_id

    Action.create(description: "Create subject suggestion", key: "new.subject_suggestion")
    Action.create(description: "Edit subject suggestion", key: "edit.subject_suggestion")
    Action.create(description: "Show subject suggestion", key: "show.subject_suggestion")
    Action.create(description: "Delete subject suggestion", key: "delete.subject_suggestion")
  end
end
