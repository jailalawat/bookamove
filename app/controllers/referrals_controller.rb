class ReferralsController < ApplicationController
  layout false

  def index
    @account = Account.find_by(subdomain: request.subdomain)
    @logo = get_logo_by_account(@account)
    @tel = @account.toll_free_phone
    @url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

    if params[:ra].present?
      @ra_user = User.find_by(email: params[:ra])
      session[:ra] = params[:ra] #if @ra_user
      @ra_email = params[:ra]
    end

    if session[:expires_at] and session[:expires_at].to_time > Time.current and not params[:shared].present?
      redirect_to "/referrals?shared=true&ra=#{session[:ra]}" if session[:ra]
    end

    if params[:shared].present? and !params[:ra].present?
      render html: "Referral Agent email is required"
    end

    if params[:shared].present? and params[:ra].present?
      session[:expires_at] = Time.current + 1.week if not session[:expires_at]
    end
  end

  def email_link
    url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"

    if params[:ra_email].present?
      params[:email].each_with_index do |email, index|
        MoverecordMail.referral_link_to_friend(params[:name][index], email, request.subdomain, params[:ra_email], url).deliver_later
      end
    end
  end

  def create
    begin
      url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
      account = Account.find_by_subdomain(request.subdomain)
      @error = ""

      if account
        # validate client doesn't exist
        client_exists = nil
        if params[:email].present? and params[:phone].blank?
          client_exists = Client.where(name: params[:name]).or(Client.where(email: params[:email])).where(account_id: account.id).first
        elsif params[:email].blank? and params[:phone].present?
          client_exists = Client.where(name: params[:name]).or(Client.where(home_phone: params[:phone])).where(account_id: account.id).first
        elsif params[:email].present? and params[:phone].present?
          client_exists = Client.where(name: params[:name]).or(Client.where(email: params[:email])).or(Client.where(home_phone: params[:phone])).where(account_id: account.id).first
        end


        if client_exists.nil?
          # create RA user
          ra_email = params[:referral_agent_email2].blank? ? params[:referral_agent_email1] : params[:referral_agent_email2]
          ra_user = User.find_by(email: ra_email)

          if not ra_user
            User.create(name: "N/A", email: ra_email, password: SecureRandom.urlsafe_base64(5), account_id: account.id)
          end

          # create move in OP
          if account.name == "oomovers"
            require "uri"
            require "net/http"
            require "net/https"

            @referral_agent_email = params[:referral_agent_email1]

            if params
              @name_error = false
              @phone_error = false
              @call_back_result = nil
              @request_error = false

              city = ""
              area_codes = ['403', '780', '250', '604', '778', '204', '506', '709', '867', '902', '867', '289', '416', '519', '613', '647', '705', '807', '905', '902', '418', '450', '514', '819', '306', '867', '000']

              if (params[:name] != '') and (params[:phone].present? or params[:email].present?)

                if params[:phone].present?
                  tmp_phone = params[:phone]
                else
                  tmp_phone = '000-000-0000'
                end

                p = 'move_event[name]=' + params[:name].to_s + '&move_event[phone]=' + tmp_phone.to_s + '&move_event[site]=bookamove.ca&move_event[source_page]=referrals' + '&move_event[email]=' + params[:email].to_s + '&move_event[comments]=' + params[:comments].to_s + '&best_time_to_call_back=' + params[:contact_time].to_s + '&move_event[pu_group]=' + city.to_s + '&referral=' + params[:referral].to_s + '&referral_agent_email1=' + params[:referral_agent_email1].to_s + '&referral_agent_email2=' + params[:referral_agent_email2].to_s + '&shared=' + params[:shared].to_s + '&share1=' + params[:share1].to_s + '&share2=' + params[:share2].to_s + '&share3=' + params[:share3].to_s + '&share4=' + params[:share4].to_s

                begin
                  #http = Net::HTTP.new('oomovers.local.loc', 3001)
                  http = Net::HTTP.new('oomovers.moveonline.com', 443)
                  http.use_ssl = true
                  path = '/customer_access/call_back_request'
                  res = http.post(path, p)
                  @call_back_result = JSON.parse(res.body)
                rescue => ex
                  @request_error = true
                end

                if @request_error or (@call_back_result and @call_back_result["status"] == 'failure')
                  @error = "Your request was unsuccessful. Please try again or call our office."
                  @error = "Phone Number in the proper format (10 digits) is required!" if (params[:phone] == '' or !(params[:phone].size > 9) or !(params[:phone] =~ /[0-9-]/) or !(area_codes.include?(params[:phone][0..2])))
                end


              elsif params[:name] == ''
                @error = "Name is required!"
              elsif  params[:phone] == '' or !(params[:phone].size > 9) or !(params[:phone] =~ /[0-9-]/) or !(area_codes.include?(params[:phone][0..2]))
                @error = "Email or Phone Number in the proper format (10 digits) is required!"
              elsif params[:email] == '' or !(params[:email] =~ /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i)
                @error = "Email in the proper format is required!"
              end

            end
          else
            @call_back_result["old_system_id"] = 0
          end


          # create move in NP
          if @call_back_result["old_system_id"] and params[:referral] == "true"
            move_record_params = {name: params[:name], email: params[:email], work_phone: params[:phone], old_system_id: @call_back_result["old_system_id"], comments: params[:comments]}
            move_record = MoveRecord.create_move_record_external(move_record_params, url, account, generate_random_password())

            move_record.move_referral_id = params[:referral_agent_email1]
            move_record.referral2 = params[:referral_agent_email2]
            move_record.move_source_id = "Referrals"
            if params[:shared] == "true"
              move_record.move_subsource_id = "5% Referral"
              move_record.who_note = "All 5% to the Client" if params[:share2] == "on"
              move_record.who_note = "All 5% to Variety Club" if params[:share4] == "on"
            else
              move_record.move_subsource_id = "10% Referral"
              move_record.who_note = "5% to Referral and 5% to the Client" if params[:share1] == "on"
              move_record.who_note = "All 10% to the Client" if params[:share2] == "on"
              move_record.who_note = "5% to you and 5% to Variety Club" if params[:share3] == "on"
              move_record.who_note = "All 10% to Variety Club" if params[:share4] == "on"
            end

            if move_record.save
              @success = true
              email_alert = EmailAlert.find_by(description: "Referral Agent Response")
              ra_email = params[:referral_agent_email2].blank? ? params[:referral_agent_email1] : params[:referral_agent_email2]
              MoverecordMail.stage_mail_sender(move_record.id.to_s, email_alert.id.to_s, "", "", "", url, ra_email).deliver_later if email_alert
              render :json => {status: 'success', referral: 'true'} if params[:external_request] == "true"
            else
              @error = "Your request was unsuccessful. Please try again or call our office."
              render :json => {status: 'failure', message: @error} if params[:external_request] == "true"
            end
          end

        else
          @error = "Sorry, referral for this client can not be done. We have identified this client records as already in our system. Only new clients can be considered as referral!"
          render :json => {status: 'failure', message: @error} if params[:external_request] == "true"
        end
      end

    rescue => exception
      @error = exception
      render :json => {status: 'failure', message: exception} if params[:external_request] == "true"
    end
  end

end
