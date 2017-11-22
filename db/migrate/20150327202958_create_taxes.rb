class CreateTaxes < ActiveRecord::Migration
  def change
    create_table :taxes do |t|
      t.string :province
      t.decimal :gst, :precision => 10, :scale => 2, :default => 0.0
      t.decimal :pst, :precision => 10, :scale => 2, :default => 0.0
      t.timestamps
    end
    add_index :taxes, :province
  end
end