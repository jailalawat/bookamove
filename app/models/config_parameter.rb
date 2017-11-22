class ConfigParameter < ActiveRecord::Base
  validates_presence_of :description, :key_description, :value, :account_id
end
