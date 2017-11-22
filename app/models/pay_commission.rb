class PayCommission < ActiveRecord::Base
  belongs_to :user

  def self.get_rate_hourly(user_id)
    pay = find_by_id(user_id)
    pay.present? ? pay.hourly : '0.0';
  end
end
