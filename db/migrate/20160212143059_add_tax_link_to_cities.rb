class AddTaxLinkToCities < ActiveRecord::Migration
  def change
    add_reference :cities, :tax, index: true, foreign_key: true
  end
end
