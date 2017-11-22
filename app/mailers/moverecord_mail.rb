class MoverecordMail < ActionMailer::Base
  default from: "operations@oomovers.com"
  include ReviewsHelper, ApplicationHelper

  def stage_mail_sender(move_record_id, alert_id, stage, user_id, template_mail, url, email_to)
    @move = MoveRecord.find_by_id(move_record_id)
    @move_date = @move.move_record_date.first.move_date
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @name = @move_record_client.name
    @client_email = @move_record_client.email
    @client_id = @move_record_client.user_id
    email_tmpl = EmailAlert.find_by_id(alert_id)
    @template_mail = email_tmpl.template #template_mail.blank? ? email_tmpl.template : template_mail
    @account = @move.account
    @move_record_id = move_record_id
    @url = url
    @logo = get_logo_by_account(@account)
    @city = @move.move_record_location_origin.first.location.city
    truck = @move.move_record_truck.truck
    truck_driver = truck.user if truck
    @truck_driver = truck_driver.name.split(' ')[0] if truck_driver
    @truck_driver_email = truck_driver.email if truck_driver

    # referral emails
    if email_tmpl.description == "Referral Agent Response" or email_tmpl.description == "Referral" or email_tmpl.description == "Referral Email Quote" or email_tmpl.description == "Referral Booking" or email_tmpl.description == "Referral Posting"
      @tel = @account.toll_free_phone
      ra_email = @move.referral2.blank? ? @move.move_referral_id : @move.referral2
      ra_user = User.find_by(email: ra_email) if not ra_email.blank?
      @ra_user_name = ra_user ? ra_user.name : "Your friend"
      @ra_user_name = "Your friend" if @ra_user_name == "N/A"
      # only ra email
      if email_tmpl.description == "Referral Agent Response" or email_tmpl.description == "Referral Booking" or email_tmpl.description == "Referral Posting"
        ra = true
        if email_tmpl.description == "Referral Posting"
          # referral 2
          if @move.move_subsource_id == "5% Referral"
            @ra_comission = (@move.total_cost.to_f * 5 / 100)
            ra_email = @move.referral2
            if @move.who_note == "All 5% to the Client"
              @referral_to_whom = "to the client"
            elsif @move.who_note == "All 5% to Variety Club"
              @referral_to_whom = "to Variety Club"
            else
              @referral_to_whom = "you"
            end
          # referral 1
          elsif @move.move_subsource_id == "10% Referral"
            @ra_comission = (@move.total_cost.to_f * 10 / 100)
            ra_email = @move.move_referral_id
            if @move.who_note == "5% to Referral and 5% to the Client"
              @referral_to_whom = "half to you and half to the client"
            elsif @move.who_note == "All 10% to the Client"
              @referral_to_whom = "to the client"
            elsif @move.who_note == "5% to you and 5% to Variety Club"
              @referral_to_whom = "half to you and half to Variety Club"
            elsif @move.who_note == "All 10% to Variety Club"
              @referral_to_whom = "to Variety Club"
            else
              @referral_to_whom = "you"
            end
          end
        end
      end
    else
      @tel = get_tel_by_move(@move, @account)
    end

    # review emails
    if email_tmpl.description == "Review Request" or email_tmpl.description == "No Review" or email_tmpl.description == "Review Thank You" or email_tmpl.description == "Complaint Response"
      if @move.move_record_location_origin.first.location.calendar_truck_group
        @links = ReviewLink.where(account_id: @account.id, calendar_truck_group_id: @move.move_record_location_origin.first.location.calendar_truck_group.id)
      else
        @links_old = review_links_by_city(@city)
      end

      @review_links = ""

      if @links
        @links.each_with_index do |link, index|
          @review_links += '</tr><tr valign="top">' if index == 4 or index == 8 or index == 12 or index == 16 or index == 20 or index == 24 or index == 28 or index == 32
          @review_links += '<td align="center" width="25%">'
          if not link[:icon].nil?
            @review_links += '<p style="margin-bottom: 0px; margin-top: 5px;"><a target="_blank" href="' + link.link_url.to_s + '" ><img src="http://' + @account.name.to_s + '.bookamove.ca/uploads/review_link/' + link[:icon].to_s + '" width="42"></a></p>'
          end
          @review_links += '<a target="_blank" href="' + link.link_url.to_s + '" style="color: #000 !important;">'
          @review_links += '<b style="font-size: 8pt; font-family: Arial, sans-serif;">' + link.name.to_s + '</b></a></td>'
        end
      end
    end

    # driver emails
    if email_tmpl.description == "Email Receive" or email_tmpl.description == "Receive 2"
      email_tmpl.description = "Move #{@move.move_contract_name}"
      email_to = truck_driver.email.nil? ? "N/A" : truck_driver.email
    end

    @number_of_men = @move.move_record_truck.number_man_id
    @hourly_rate = @move.move_record_cost_hourly.hourly_rate
    @estimated_hours = @move.move_record_cost_hourly.estimate_time
    @token = @move.token
    @driver_token = @move.driver_token
    @oomovers_owners_care = '<table cellspacing="0" cellpadding="0" border="0" width="100%"><tr align="center"><td><a href="https://www.oomovers.com/save_money" style="font-family: Arial, sans-serif; color: white; font-weight: bold">Save Money</a></td><td><a href="https://www.oomovers.com/feel_secure" style="font-family: Arial, sans-serif; color: white; font-weight: bold">Feel Secure</a></td><td><a href="https://www.oomovers.com/owners_care" style="font-family: Arial, sans-serif; color: white; font-weight: bold">Owners Care</a></td></tr></table>' if @account.name == "oomovers"

    email_tmpl.description = "My Move" if email_tmpl.description == "New Move"
    email_tmpl.description = "Move Confirmation - ACTIONS REQUIRED" if email_tmpl.description == "Confirmation"
    email_tmpl.description = "Move Re-Confirmation - ACTIONS REQUIRED" if email_tmpl.description == "Reconfirmation 2" or email_tmpl.description == "Reconfirmation 7"
    email_tmpl.description = "Reward Your Mover" if email_tmpl.description == "Review Request"
    email_tmpl.description = "Reward Your Mover- Delivery Failed" if email_tmpl.description == "No Review"
    email_tmpl.description = "Thank you for your Review" if email_tmpl.description == "Review Thank You"

    if ra
      # ra email
      mail(to: email_to.blank? ? ra_email : email_to, :from => @account.email, subject: email_tmpl.description) if not ra_email.blank? or not email_to.blank?
    else
      # user email
      mail(to: email_to.blank? ? @client_email : email_to, :from => @account.email, subject: email_tmpl.description)
    end

  end

  def confirm_move_record(email, subject, move_record_id, url)
    @move = MoveRecord.find_by_id(move_record_id)
    @move_id = move_record_id
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @name = @move_record_client.name
    @account = @move.account
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @token = @move.token
    @city = @move.move_record_location_origin.first.location.city

    email = @move_record_client.email if email.blank?
    @ra_email = email

    mail(to: email, from: @account.email, subject: "URGENT - Move Confirmation - ACTION REQUIRED")
  end

  def follow_up(move)
    @name = move.move_record_client.first.client.name
    @start_time = move.blank? ? nil : move.move_record_date.first.move_date.blank? ? nil : move.move_record_cost_hourly.start
    @account = move.account
    @move_date = move.move_record_date.first.move_date
    @move = move

    mail(:to => move.move_record_client.first.client.email, :from => @account.email, :subject => 'Thank you for your move with ' + @account.name + ' - ' + @name + ' (' + move.id.to_s + ')')
  end

  def proposal(move, document_type)
    @name = move.move_record_client.first.client.name
    @start_time = move.blank? ? nil : move.move_record_date.first.move_date.blank? ? nil : move.move_record_cost_hourly.start
    @account = move.account
    @move_date = move.move_record_date.first.move_date
    @move = move

    document_type = document_type
    move_type = Pdf::LOCAL
    p = Pdf.new
    attachments["OOmovers_#{Pdf.document_title(move, document_type, true)}_#{move.id.to_s}.pdf"] = {:mime_type => 'application/pdf', :content => p.move(move, document_type)}
    mail(:to => move.move_record_client.first.client.email, :from => @account.email, :subject => 'Thank you for your move with ' + @account.name + ' - ' + @name + ' (' + move.id.to_s + ')')
  end

  def invoice(move, document_type, url)
    @name = move.move_record_client.first.client.name
    @start_time = move.blank? ? nil : move.move_record_date.first.move_date.blank? ? nil : move.move_record_cost_hourly.start
    @account = move.account
    @move_date = move.move_record_date.first.move_date
    @move = move
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @token = @move.token
    @city = @move.move_record_location_origin.first.location.city
    @ra_email = move.move_record_client.first.client.email

    document_type = document_type
    move_type = Pdf::LOCAL
    p = Pdf.new
    attachments["#{@account.name}_#{Pdf.document_title(move, document_type, true)}_#{move.id.to_s}.pdf"] = {:mime_type => 'application/pdf', :content => p.move(move, document_type)}
    mail(:to => move.move_record_client.first.client.email, :from => @account.email, :subject => 'Move Invoice')
  end

  def receipt(move, document_type, url)
    @name = move.move_record_client.first.client.name
    @start_time = move.blank? ? nil : move.move_record_date.first.move_date.blank? ? nil : move.move_record_cost_hourly.start
    @account = move.account
    @move_date = move.move_record_date.first.move_date
    @move = move
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @token = @move.token
    @city = @move.move_record_location_origin.first.location.city
    @move_record_client = MoveRecordClient.where(move_record_id: move.id).first.client
    @ra_email = @move_record_client.email

    document_type = document_type
    move_type = Pdf::LOCAL
    p = Pdf.new
    attachments["#{@account.name}_#{Pdf.document_title(move, document_type, true)}_#{move.id.to_s}.pdf"] = {:mime_type => 'application/pdf', :content => p.move(move, document_type)}
    mail(:to => move.move_record_client.first.client.email, :from => @account.email, :subject => 'Move Receipt')
  end

  def cc_consent(move, url)
    @name = move.move_record_client.first.client.name
    @start_time = move.blank? ? nil : move.move_record_date.first.move_date.blank? ? nil : move.move_record_cost_hourly.start
    @account = move.account
    @move_date = move.move_record_date.first.move_date
    @move = move
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @token = @move.token
    @city = @move.move_record_location_origin.first.location.city
    @move_record_client = MoveRecordClient.where(move_record_id: move.id).first.client
    @ra_email = @move_record_client.email

    p = Pdf.new
    attachments["#{@account.name}_CCConsent" + '_' + move.id.to_s + '.pdf'] = {:mime_type => 'application/pdf', :content => p.cc_consent(@account, @logo, @tel)}
    mail(:to => move.move_record_client.first.client.email, :from => @account.email, :subject => 'Credit Card Consent Form')
  end

  def non_disclosure(move, url)
    @name = move.move_record_client.first.client.name
    @start_time = move.blank? ? nil : move.move_record_date.first.move_date.blank? ? nil : move.move_record_cost_hourly.start
    @account = move.account
    @move_date = move.move_record_date.first.move_date
    @move = move
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @token = @move.token
    @city = @move.move_record_location_origin.first.location.city
    @move_record_client = MoveRecordClient.where(move_record_id: move.id).first.client
    @ra_email = @move_record_client.email

    p = Pdf.new
    attachments["#{@account.name}_settlement_agreement" + '_' + move.id.to_s + '.pdf'] = {:mime_type => 'application/pdf', :content => p.non_disclosure(move.id, @account, @logo, @tel, false)}
    mail(:to => move.move_record_client.first.client.email, :from => @account.email, :subject => 'Settlement Agreement')
  end

  def customer_message(email, name, subject, message, move_record_id, message_id, url)
    @name = name
    @move = MoveRecord.find_by_id(move_record_id)
    @move_contract_name = @move.move_contract_name
    @move_date = @move.move_record_date.first.move_date
    @move_record_name = name
    @account = MoveRecord.find_by_id(move_record_id).account
    @message = message
    @subject = subject
    @move_record_id = move_record_id
    @url = url
    @message_id = message_id
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @token = @move.token
    @city = @move.move_record_location_origin.first.location.city
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @ra_email = @move_record_client.email

    mail(to: email, from: @account.email, subject: subject)
  end

  def review(move_record_id, url)
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @name = @move_record_client.name
    @move = MoveRecord.find(move_record_id)
    @account = @move.account
    @city = @move.move_record_location_origin.first.location.city
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    #@links = review_links_by_city(@city)
    @token = @move.token
    truck = @move.move_record_truck.truck
    truck_driver = truck.user if truck
    @truck_driver = truck_driver.name.split(' ')[0] if truck_driver
    @ra_email = @move_record_client.email

    mail(to: @move.move_record_client.first.client.email, :from => @account.email, subject: 'Reward Your Mover')
  end

  def review2(move_record_id, url)
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @name = @move_record_client.name
    @move = MoveRecord.find(move_record_id)
    @account = @move.account
    @city = @move.move_record_location_origin.first.location.city
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    if @move.move_record_location_origin.first.location.calendar_truck_group
      @links = ReviewLink.where(account_id: @account.id, calendar_truck_group_id: @move.move_record_location_origin.first.location.calendar_truck_group.id)
    else
      @links_old = review_links_by_city(@city)
    end
    @token = @move.token
    truck = @move.move_record_truck.truck
    truck_driver = truck.user if truck
    @truck_driver = truck_driver.name.split(' ')[0] if truck_driver
    @ra_email = @move_record_client.email

    mail(to: @move.move_record_client.first.client.email, :from => @account.email, subject: 'Thank you for your Review')
  end

  def review_thank_you(move_record_id, url)
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @name = @move_record_client.name
    @move = MoveRecord.find(move_record_id)
    @account = @move.account
    @city = @move.move_record_location_origin.first.location.city
    @url = url
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)
    @ra_email = @move_record_client.email

    mail(to: @move.move_record_client.first.client.email, :from => @account.email, subject: 'Thank you for your Review')
  end

  def complaint_response(move_record_id)
    @move_record_client = MoveRecordClient.where(move_record_id: move_record_id).first.client
    @name = @move_record_client.name
    @move = MoveRecord.find(move_record_id)
    @account = @move.account
    @city = @move.move_record_location_origin.first.location.city
    @logo = get_logo_by_account(@account)
    @tel = get_tel_by_move(@move, @account)

    mail(to: @move.move_record_client.first.client.email, :from => @account.email, subject: 'Bad Review')
  end

  def referral_link_to_friend(name, email, subdomain, ra_email, url)
    @account = Account.find_by(subdomain: subdomain)
    @logo = get_logo_by_account(@account)
    @tel = @account.toll_free_phone
    @url = url
    @ra = User.where(email: ra_email).first
    @name = name
    if ra_email.blank?
      @ra_email = @account.email
    else
      @ra_email = ra_email
    end

    mail(to: email, :from => @ra_email, subject: 'Earn Referral Rewards $25-50+')
  end

end
