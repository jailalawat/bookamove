class ReplicateToOpJob < ApplicationJob
  queue_as :default
  require "uri"
  require "net/http"
  require "net/https"

  def perform(move_id, account_id, url)
    if move_id and account_id
      account = Account.find(account_id)
      move = MoveRecord.find(move_id)

      if (account and account.name == "oomovers") and (move and not move.old_system_id)
        client = move.move_record_client.first.client
        name = client.name
        phone = client.home_phone.blank? ? "000-000-0000" : client.home_phone
        email = client.email

        move_date = move.move_record_date.first.move_date
        move_time_start = move.move_record_cost_hourly.start.blank? ? "00:00" : move.move_record_cost_hourly.start
        move_time_stop = move.move_record_cost_hourly.stop.blank? ? "00:00" : move.move_record_cost_hourly.stop
        move_date_start = Time.parse(move_date.to_s).change(hour: move_time_start.to_time.hour, min: move_time_start.to_time.min)
        move_date_stop = Time.parse(move_date.to_s).change(hour: move_time_stop.to_time.hour, min: move_time_stop.to_time.min)

        move_cost = move.move_record_cost_hourly.move_cost
        other_cost = move.move_record_other_cost.other_cost
        surcharge = move.move_record_surcharge.surcharge
        packing = move.move_record_packing.total_packing
        posted_date = DateTime.now
        origin_city = move.move_record_location_origin.first.location.city
        destination_city = move.move_record_location_destination.first.location.city
        taxes = move.move_record_location_origin.first.location.calendar_truck_group.tax
        payment = move.move_record_payment

        # estimator/quote user email
        estimator = MoveStatusEmailAlert.find_by(account_id: account_id, move_record_id: move_id, contact_stage_id: ContactStage.where(account_id: account_id, sub_stage: "Quote").pluck(:id).first)
        if estimator
          estimator_email = User.find_by(account_id: account_id, id: estimator.user_id).email
        else
          estimator = MoveStatusEmailAlert.find_by(account_id: account_id, move_record_id: move_id)
          estimator_email = User.find_by(account_id: account_id, id: estimator.user_id).email if estimator
        end

        # booker user email
        booker = MoveStatusEmailAlert.find_by(account_id: account_id, move_record_id: move_id, contact_stage_id: ContactStage.where(account_id: account_id, stage: "Book").pluck(:id).first)
        booker_email = User.find_by(account_id: account_id, id: booker.user_id).email if booker

        # truck name
        truck = move.move_record_truck.truck
        truck_name = truck.description if truck

        # send data to OP
        p = "name=#{name}&phone=#{phone}&email=#{email}&start_time=#{move_date_start}&end_time=#{move_date_stop}&posted_on=#{posted_date}&emailed=1&customer_template_emailed=1&new_system_id=#{move.id}&pu_group=#{origin_city}&pu_city=#{origin_city}&d_group=#{destination_city}&d_city=#{destination_city}&estimator_email=#{estimator_email}&booker_email=#{booker_email}&truck_name=#{truck_name}&move_cost=#{move_cost}&client_received=#{move.payment}&received=#{move.deposit}&other_cost=#{other_cost}&surcharge=#{surcharge}&packing=#{packing}&tax1=#{taxes.gst}&tax2=#{taxes.pst}&payment_type=#{payment.type_payment}&payment=#{payment.payment_alert_id}&number_card=#{payment.number_card}&exp=#{payment.exp}&cvc=#{payment.cvc}&number_transaction=#{payment.number_transaction}&pre_auth=#{payment.pre_auth}&payment_date=#{payment.date}&source=#{move.move_source_id}&sub_source=#{move.move_subsource_id}"

        #http = Net::HTTP.new('oomovers.local.loc', 3001)
        http = Net::HTTP.new('oomovers.moveonline.com', 443)
        http.use_ssl = true
        path = '/replicate_move_from_new_system'
        http.post(path, p)
      end

    end
  end
end
