class ContactStageEmail < ApplicationRecord
  belongs_to :contact_stage
  belongs_to :email_alert

end
