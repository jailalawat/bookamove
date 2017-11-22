class ApiProcessesController < ApplicationController

  def create_external_move_record
    respond_to do |format|
      begin
        url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
        account = Account.find_by_subdomain(request.subdomain)

        unless account.blank?
          move_record_params = {name: params[:move_event][:name], email: params[:move_event][:email], work_phone: params[:move_event][:phone], comments: params[:move_event][:comments]}
          move_record = MoveRecord.create_move_record_external(move_record_params, url, account, generate_random_password())

          # send Free Quote Response email and log
          email = EmailAlert.find_by(description: "Free Quote Response", account_id: account.id)
          user_id = User.where(name: "auto email system").pluck(:id).first

          if email
            MoverecordMail.stage_mail_sender(move_record.id, email.id, "", user_id, email.template, url, "").deliver_later

            message = MessagesMoveRecord.new
            message.account_id = account.id
            message.user_id = user_id
            message.subject = email.description.to_s + " Email"
            message.body = "" #email.template
            message.move_record_id = move_record.id
            message.message_type = 'email'
            message.save
          end

          # set source/subsource
          if params[:source].present?
            source = MoveSource.find_by(description: params[:source], account_id: account.id)
            move_record.move_source_id = source.description if source
          end

          if params[:subsource].present?
            subsource = MoveSubsource.find_by(description: params[:subsource], account_id: account.id)
            move_record.move_subsource_id = subsource.description if subsource
          end

          if move_record.save
            format.json { render json: {:status => 'success', :move_record => move_record.id} }
          end
        end

        format.json { render json: {:status => 'failure', :message => 'Account not found.'} }
      rescue => exception
        errors = 'A problem has occurred. Try again.'
        format.json { render json: {:status => 'failure', :message => exception} }
      end
    end
  end

  def replicate_old_system_move
    # add domain validation
    if not params[:name].blank? and not params[:email].blank?
      begin
        url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
        account = Account.find_by(name: "oomovers")

        # input params
        move_record_params = {name: params[:name], email: params[:email], city: params[:city], old_system_id: params[:old_system_id], move_cost: params[:move_cost]}
        truck_name = params[:truck_name]
        truck_user_name = params[:truck_user_name]
        truck_user_email = params[:truck_user_email]

        # do review process
        if params[:type] == "review"
          # create move
          if not params[:old_system_id].blank?
            move_record = MoveRecord.find_by(old_system_id: params[:old_system_id])
          end

          if not move_record
            move_record = MoveRecord.create_move_record_external(move_record_params, url, account, generate_random_password())
          end

          # create truck
          if truck_name
            truck = Truck.find_by(description: truck_name)

            if not truck
              truck = Truck.create(description: truck_name, active: true, account_id: 2)
            end
          end

          # create truck user
          if truck_user_email
            user = User.find_by(email: truck_user_email)

            if not user
              user = User.create(name: truck_user_name, email: truck_user_email, password: SecureRandom.urlsafe_base64(5), account_id: 2)
            end
          end

          # assign user to the truck
          truck.update(driver: user.id) if user

          # assign truck to the move
          move_record.move_record_truck.update(truck_id: truck.id) if truck

          # send review email
          if params[:email_type] == "review"
            if params[:manual] == "true"
              MoverecordMail.review(move_record.id, url).deliver_later
              MoveRecord.update(move_record.id, review_send: true)

              log_message = MessagesMoveRecord.new
              log_message.account_id = account.id
              log_message.user_id = User.where(name: "auto email system").pluck(:id).first
              log_message.subject = 'Review Request Email'
              log_message.body = ""
              log_message.move_record_id = move_record.id
              log_message.message_type = 'email'
              log_message.save
            else
              if not move_record.review_send
                MoverecordMail.review(move_record.id, url).deliver_later
                MoveRecord.update(move_record.id, review_send: true)

                log_message = MessagesMoveRecord.new
                log_message.account_id = account.id
                log_message.user_id = User.where(name: "auto email system").pluck(:id).first
                log_message.subject = 'Review Request Email'
                log_message.body = ""
                log_message.move_record_id = move_record.id
                log_message.message_type = 'email'
                log_message.save
              end
            end
          end

          # send no review email
          if params[:email_type] == "review2"
            if params[:manual] == "true"
              MoverecordMail.review2(move_record.id, url).deliver_later
              MoveRecord.update(move_record.id, review2_send: true)

              log_message = MessagesMoveRecord.new
              log_message.account_id = account.id
              log_message.user_id = User.where(name: "auto email system").pluck(:id).first
              log_message.subject = 'No Review Email'
              log_message.body = ""
              log_message.move_record_id = move_record.id
              log_message.message_type = 'email'
              log_message.save
            end
          end

          # send review thank you email
          if params[:email_type] == "review_thank_you"
            if params[:manual] == "true"
              MoverecordMail.review_thank_you(move_record.id, url).deliver_later
              MoveRecord.update(move_record.id, review_thank_you_send: true)

              log_message = MessagesMoveRecord.new
              log_message.account_id = account.id
              log_message.user_id = User.where(name: "auto email system").pluck(:id).first
              log_message.subject = 'Review Thank You Email'
              log_message.body = ""
              log_message.move_record_id = move_record.id
              log_message.message_type = 'email'
              log_message.save
            end
          end

          # send complaint response email
          if params[:email_type] == "complaint_response"
            if params[:manual] == "true"
              MoverecordMail.complaint_response(move_record.id).deliver_later
              MoveRecord.update(move_record.id, complaint_response_send: true)

              log_message = MessagesMoveRecord.new
              log_message.account_id = account.id
              log_message.user_id = User.where(name: "auto email system").pluck(:id).first
              log_message.subject = 'Complaint Response Email'
              log_message.body = ""
              log_message.move_record_id = move_record.id
              log_message.message_type = 'email'
              log_message.save
            end
          end
        # do referral process
        elsif params[:type] == "referral" and params[:referral] == "true"
          move_record = MoveRecord.find_by(old_system_id: params[:old_system_id])

          if move_record and move_record.move_source_id == "Referrals"
            ra_email = move_record.referral2.blank? ? move_record.move_referral_id : move_record.referral2

            # on book
            if params[:stage] == "book" and ra_email
              book_id = ContactStage.where(account_id: account.id, stage: "Book").pluck(:id).first
              is_booked = MoveStatusEmailAlert.where(account_id: account.id, move_record_id: move_record.id, contact_stage_id: book_id).first

              if not is_booked
                # update move date
                move_record.move_record_date.update(move_date: params[:book_date].to_date)

                # send email and log_message
                email_alert = EmailAlert.find_by(description: "Referral Booking")
                MoverecordMail.stage_mail_sender(move_record.id.to_s, email_alert.id.to_s, "", "", "", url, ra_email).deliver_later if email_alert

                log_message = MessagesMoveRecord.new
                log_message.account_id = account.id
                log_message.user_id = User.where(name: "auto email system").pluck(:id).first
                log_message.subject = "Referral Booking Email"
                log_message.body = ""
                log_message.move_record_id = move_record.id
                log_message.message_type = 'email'
                log_message.save

                # create book stage
                stage_name = "Book"

                move_status_email = MoveStatusEmailAlert.new
                move_status_email.move_record_id = move_record.id
                move_status_email.account_id = account.id
                move_status_email.contact_stage_id = book_id
                #move_status_email.user_id = current_user.id
                move_status_email.save

                message = MessagesMoveRecord.new
                message.account_id = account.id
                #message.user_id = current_user.id
                message.subject = 'Contact Stage ' + stage_name
                message.body = 'Contact Stage ' + stage_name
                message.move_record_id = move_record.id
                message.save
              end
            end

            # on post
            if params[:stage] == "post" and ra_email
              post_id = ContactStage.where(account_id: account.id, sub_stage: "Post").pluck(:id).first
              is_posted = MoveStatusEmailAlert.where(account_id: account.id, move_record_id: move_record.id, contact_stage_id: post_id).first

              if not is_posted
                # update move cost
                move_record.update(total_cost: params[:move_cost])

                # send email and log_message
                email_alert = EmailAlert.find_by(description: "Referral Posting")
                MoverecordMail.stage_mail_sender(move_record.id.to_s, email_alert.id.to_s, "", "", "", url, ra_email).deliver_later if email_alert

                log_message = MessagesMoveRecord.new
                log_message.account_id = account.id
                log_message.user_id = User.where(name: "auto email system").pluck(:id).first
                log_message.subject = "Referral Posting Email"
                log_message.body = ""
                log_message.move_record_id = move_record.id
                log_message.message_type = 'email'
                log_message.save

                # create post stage
                stage_name = "Post"

                move_status_email = MoveStatusEmailAlert.new
                move_status_email.move_record_id = move_record.id
                move_status_email.account_id = account.id
                move_status_email.contact_stage_id = post_id
                #move_status_email.user_id = current_user.id
                move_status_email.save

                log_message2 = MessagesMoveRecord.new
                log_message2.account_id = account.id
                #message.user_id = current_user.id
                log_message2.subject = 'Contact Stage ' + stage_name
                log_message2.body = 'Contact Stage ' + stage_name
                log_message2.move_record_id = move_record.id
                log_message2.save

                # referral payout message
                # referral 2
                if move_record.move_subsource_id == "5% Referral"
                  ref_title = "5%"
                  ra_comission = (move_record.total_cost.to_f * 5 / 100)
                  to_whom = move_record.who_note.blank? ? "5% to referral1 and 5% to referral2" : "5% to referral1 and "+ move_record.who_note.to_s.gsub("All ", "")
                  # referral 1
                elsif move_record.move_subsource_id == "10% Referral"
                  ref_title = "10%"
                  ra_comission = (move_record.total_cost.to_f * 10 / 100)
                  to_whom = move_record.who_note.blank? ? "All to the Referral1" : move_record.who_note
                end

                old_system_id_str = ". Old System Id: #{move_record.old_system_id}"

                log_message3 = MessagesMoveRecord.new
                log_message3.account_id = account.id
                log_message3.user_id = User.where(name: "auto email system").pluck(:id).first
                log_message3.subject = "Referral payout #{ref_title}"
                log_message3.body = "Referral commission: $#{ra_comission}. #{to_whom}#{old_system_id_str}"
                log_message3.move_record_id = move_record.id
                log_message3.save

                #internal message to accounting role
                accounting_id = Role.find_by(name: "Accounting", account_id: account.id).subtask_staff_group.id
                message2 = TaskMessagesMoveRecord.new
                message2.account_id = account.id
                message2.subtask_staff_group_id = accounting_id
                message2.messages_move_record_id = log_message3.id
                message2.readed = false
                message2.save

              end
            end

          end
        end

        render json: {:status => 'success', :move_record => move_record.id}

      rescue => exception
        errors = exception
        render json: {:status => 'failure', :message => exception}
      end
    end
  end

  def public_info
    @disable_icon = 'fa fa-check-circle icon-gray disable'

    @move_record = MoveRecord.find(params[:id])

    @settings = MoveRecordDefaultSettings.find_by(account_id: @move_record.account_id)
    @move_type_data = MoveType.where(account_id: @move_record.account_id, active: 1)
    @truck_data = Truck.where(account_id: @move_record.account_id, active: 1)
    @move_type_alert = MoveTypeAlert.where(account_id: @move_record.account_id, active: 1)
    @equipment_alert = EquipmentAlert.where(account_id: @move_record.account_id, active: 1)
    @payment_alert = PaymentAlert.where(account_id: @move_record.account_id, active: 1)
    @packing_alert = PackingAlert.where(account_id: @move_record.account_id, active: 1)
    @time_alert = TimeAlert.where(account_id: @move_record.account_id, active: 1)
    @move_source = MoveSource.where(account_id: @move_record.account_id, active: 1)
    @move_keyword = MoveKeyword.where(account_id: @move_record.account_id, active: 1)
    @move_webpage = MoveWebpage.where(account_id: @move_record.account_id, active: 1)
    @move_referral = MoveReferral.where(account_id: @move_record.account_id, active: 1)
    @move_alert = MoveSourceAlert.where(account_id: @move_record.account_id, active: 1)
    @cargo_type = CargoType.where(account_id: @move_record.account_id, active: 1)
    @cargo_alert = CargoAlert.where(account_id: @move_record.account_id, active: 1)
    @access_alert = AccessAlert.where(account_id: @move_record.account_id, active: 1)
    #@users			 = RoleUser.where(:account_id => @move_record.account_id , role_id:[6,7,8]).includes(:user)
    @users = RoleUser.where(:account_id => @move_record.account_id).includes(:user)
    @users = @users.blank? ? @users : @users.map { |v| v.user }
    @provinces = Province.all
    @rooms = Room.all
    @all_calendar_groups = CalendarTruckGroup.where(account_id: @move_record.account_id, active: 1)
    @all_staff_users = []
    @all_subtask = SubtaskStaffGroup.where(account_id: @move_record.account_id, mailbox: true, active: true)
    @subject_suggestions = SubjectSuggestion.where(account_id: @move_record.account_id)


    @move_record_clients = MoveRecordClient.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @move_record_origins = MoveRecordLocationOrigin.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @move_record_destinations = MoveRecordLocationDestination.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @move_record_dates = MoveRecordDate.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @move_record_trucks = MoveRecordTruck.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @move_record_cost_hourly = MoveRecordCostHourly.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_packing = MoveRecordPacking.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_other_cost = MoveRecordOtherCost.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_surchage = MoveRecordSurcharge.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_flat_rate = MoveRecordFlatRate.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_discount = MoveRecordDiscount.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_insurance = MoveRecordInsurance.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_fuel_cost = MoveRecordFuelCost.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_payment = MoveRecordPayment.find_by_account_id_and_move_record_id(@move_record.account_id, params[:id])
    @move_record_contact_stage = MoveStatusEmailAlert.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @calc_cargo = MoveRecordCargo.where(account_id: @move_record.account_id, move_record_id: params[:id])
    @current_user = OpenStruct.new({:id => @move_record_clients[0].client.user_id})

    move_record_array_stages = []
    @move_record_contact_stage.each do |contact_stage|
      move_record_array_stages.push({id: contact_stage.contact_stage_id,
                                     email: {contact_stage.email_alert_id => {id: contact_stage.email_alert_id}}})
    end

    @move_record_json_stages = move_record_array_stages.to_json

    @move_booked = MoveStatusEmailAlert.exists?(:account_id => @move_record.account_id, :move_record_id => params[:id], :contact_stage_id => ContactStage.where(account_id: @current_user.account_id, stage: "Book").pluck(:id).first)

    @full_messages = []
    move_record_customer = @move_record.move_record_client.first.client.user_id
    move_record_driver = nil
    custom_messages = EmailMessagesMoveRecord.where(account_id: @current_user.account_id, user_id: @current_user.id)
    @all_messages = MessagesMoveRecord.where('account_id = ? and move_record_id = ? and user_id = ? and parent_id IS NULL',
                                             @move_record.account_id, @move_record.id, move_record_customer)
                        .order(created_at: (params[:message_sort].present? ? (params[:message_sort] == 'DESC' ? :asc : :desc) : :desc))


    @all_messages.each do |info_message|
      @full_messages.push({main: info_message, reply: []})
    end
    @full_messages = @full_messages.uniq { |e| e[:main] }

  end

  def create_message_move_record_public
    @move_record = MoveRecord.find(params[:move_record])
    @message = MessagesMoveRecord.new
    @message.account_id = @move_record.id
    @message.user_id = @move_record.move_record_client.first.client.user_id
    @message.subject = params[:subject]
    @message.urgent = params[:urgent]
    @message.move_record_id = params[:move_record]
    @message.body = params[:template_mail].present? ? (!params[:template_mail].blank? ? params[:template_mail] : params[:body]) : params[:body]
    respond_to do |format|
      if @message.save
        params[:to] ||= []
        params[:to].each do |temp_data|
          if (temp_data.match(/task_\d+/))
            u_messages = TaskMessagesMoveRecord.new
            u_messages.subtask_staff_group_id = temp_data.gsub('task_', '').to_i
            u_messages.messages_move_record_id = @message.id
            u_messages.account_id = @message.account_id
            u_messages.readed = false
            u_messages.save
          end
        end

        params[:file] ||= []
        params[:file].each do |file|
          file = upload_attachment(file)
          attachment = MessagesMoveRecordAttachment.new
          attachment.messages_move_record_id = @message.id
          attachment.file_path = file[:url]
          attachment.name = file[:name]
          attachment.account_id = @message.account_id
          attachment.save
        end
        format.json { render json: @message }
      else
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end

  def upload_attachment(file_param)
    name = (rand() * 4).to_s + '_' + Time.now.to_i.to_s + '_' + file_param.original_filename
    return {url: upload_bucket_file(file_param, name, 'mmo-attachments-dev'), name: name}
  end

  def move_record_params
    params[:move_record].permit!.to_h
  end
end
