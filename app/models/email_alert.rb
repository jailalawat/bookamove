class EmailAlert < ActiveRecord::Base
  has_many :contact_stage_emails, :dependent => :delete_all
  has_many :contact_stages, through: :contact_stage_emails

end
