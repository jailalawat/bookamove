class MoveRecordDefaultSettings < ActiveRecord::Base
  validates :number_of_clients, numericality: {greater_than: 0}
  validates :number_of_trucks, numericality: {greater_than: 0}
  validates :number_of_origin, numericality: {greater_than: 0}
  validates :number_of_destination, numericality: {greater_than: 0}
  validates :number_of_date, numericality: {greater_than: 0}

  belongs_to :move_type
  belongs_to :move_type_alert
  belongs_to :equipment_alert
  belongs_to :payment_alert
  belongs_to :move_source
  belongs_to :move_keyword
  belongs_to :move_webpage
  belongs_to :move_referral
  belongs_to :move_source_alert
  belongs_to :time_alert
  belongs_to :cargo_type
  belongs_to :cargo_alert
  belongs_to :access_alert
  belongs_to :packing_alert
  belongs_to :move_stage_alert, :foreign_key => 'move_stage_alerts_id'
  belongs_to :origin_access_alert, :class_name => 'AccessAlert', :foreign_key => 'origin_access_alert_id'
  belongs_to :destination_access_alert, :class_name => 'AccessAlert', :foreign_key => 'destination_access_alert_id'
end
