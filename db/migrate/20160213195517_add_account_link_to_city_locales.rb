class AddAccountLinkToCityLocales < ActiveRecord::Migration
  def change
    add_reference :city_locales, :account, index: true, foreign_key: true
  end
end
