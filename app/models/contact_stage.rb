class ContactStage < ActiveRecord::Base
  has_many :contact_stage_emails, :dependent => :delete_all
  has_many :email_alerts, through: :contact_stage_emails

end