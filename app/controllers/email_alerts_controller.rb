class EmailAlertsController < ApplicationController
  include ReviewsHelper
  before_filter :current_user
  before_action :set_email_alert, only: [:edit, :update, :destroy]

  def index
    @email_alerts = EmailAlert.where(account_id: @current_user.account_id)
    @stages = ContactStage.all
  end

  def edit
    validate_permissions("create_edit.emails") ? '' : return
    @email_alert = EmailAlert.find(params[:id])
    @stages = ContactStage.all
  end

  def new
    validate_permissions("create_edit.emails") ? '' : return
    @email_alert = EmailAlert.new
  end

  def template_email
    @template_mail = EmailAlert.find_by_id(params[:contact_email]) if params[:contact_email]
    @account = Account.find_by_id(@current_user.account_id)
    @logo = get_logo_by_account(@account)
    @url = "http://#{request.subdomain}.#{request.domain}:#{request.port.to_s}"
    @tel = @account.toll_free_phone
    @move = MoveRecord.find_by_id(params[:move_id]) if params[:move_id]
    @move_date = @move.move_record_date.first.move_date
    @tel = get_tel_by_move(@move, @account) if @move
    @number_of_men = @move.move_record_truck.number_man_id if @move
    @hourly_rate = @move.move_record_cost_hourly.hourly_rate if @move
    @estimated_hours = @move.move_record_cost_hourly.estimate_time if @move
    @move_record_client = MoveRecordClient.where(move_record_id: params[:move_id]).first.client if params[:move_id]
    @name = @move_record_client.name if @move_record_client
    @oomovers_owners_care = '<table cellspacing="0" cellpadding="0" border="0" width="100%"><tr align="center"><td><a href="https://www.oomovers.com/save_money" style="font-family: Arial, sans-serif !important; color: white !important; font-weight: bold">Save Money</a></td><td><a href="https://www.oomovers.com/feel_secure" style="font-family: Arial, sans-serif !important; color: white !important; font-weight: bold">Feel Secure</a></td><td><a href="https://www.oomovers.com/owners_care" style="font-family: Arial, sans-serif !important; color: white !important; font-weight: bold">Owners Care</a></td></tr></table>' if @account.name == "oomovers"
    @city = @move.move_record_location_origin.first.location.city if @move
    truck = @move.move_record_truck.truck if @move
    truck_driver = truck.user if truck
    @truck_driver = truck_driver.name.split(' ')[0] if truck_driver
    @truck_driver_email = truck_driver.email if truck_driver

    if not params[:manual] == "true"
      # review emails
      if @template_mail.description == "Review Request" or @template_mail.description == "No Review" or @template_mail.description == "Review Thank You" or @template_mail.description == "Complaint Response"
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

      respond_to do |format|
        format.json { render json: { template: @template_mail.template.gsub("{site}", @account.site).gsub("{logo}", "<img src='#{@logo}' width='192' border='0'>").gsub("{tel}", @tel).gsub("{url}", @url.gsub(":80", "")).gsub("{address}", @account.address).gsub("{working_hours}", @account.working_hours).gsub("{account_id}", @account.id.to_s).gsub("{account_name}", @account.name.gsub("oomovers", "<span style='color: rgb(231,64,63);'>oo</span> movers")).gsub("{number_of_men}", @number_of_men.to_s).gsub("{rate}", @hourly_rate.to_s).gsub("{oomovers_ad_top}", "<img src='http://bookamove.ca/images/ad_top.png' width='500'><br><br>").gsub("{oomovers_ad_bottom}", "<br><br><img src='http://bookamove.ca/images/ad_bottom.png' width='500'>").gsub("{oomovers_owners_care}", @oomovers_owners_care.to_s).gsub("{name}", @name.to_s).gsub("color: white;", "color: white !important;").gsub("{truck_driver}", @truck_driver.to_s).gsub("{city}", @city.to_s).gsub("{review_links}", @review_links.to_s).gsub("{contract_name}", @move.move_contract_name.to_s).gsub("{move_date}", @move_date.present? ? @move_date.strftime("%d/%m/%Y").to_s : "").gsub("{truck_driver_email}", @truck_driver_email.to_s).gsub("{estimated_hours}", @estimated_hours.to_s) } }
      end
    else
      if params[:type] == "cc_consent"
        view = render_to_string template: 'moverecord_mail/cc_consent.html.erb', :layout => false
      elsif params[:type] == "non_disclosure"
        view = render_to_string template: 'moverecord_mail/non_disclosure.html.erb', :layout => false
      elsif params[:type] == "invoice"
        view = render_to_string template: 'moverecord_mail/invoice.html.erb', :layout => false
      elsif params[:type] == "receipt"
        view = render_to_string template: 'moverecord_mail/receipt.html.erb', :layout => false
      end

      respond_to do |format|
        format.json { render json: { template: view } }
      end
    end

  end

  ####new
  def create
    validate_permissions("create_edit.emails") ? '' : return
    @email_alert = EmailAlert.new(description: params[:description], template: params[:template], stage_num: params[:stage_num], instructions: params[:instructions])
    @email_alert.account_id = @current_user.account_id

    if @email_alert.save
      render json: @email_alert
    else
      render json: @email_alert.errors, status: :unprocessable_entity
    end
  end

  def update
    validate_permissions("create_edit.emails") ? '' : return
    @email_alert = EmailAlert.find(params[:id])

    if @email_alert.update(description: params[:description], template: params[:template], instructions: params[:instructions])
      render json: @email_alert
    else
      render json: @email_alert.errors, status: :unprocessable_entity
    end
  end

  def destroy
    validate_permissions("create_edit.emails") ? '' : return
    @email_alert = EmailAlert.find(params[:id])
    @email_alert.destroy
  end

  def update_email_alert_enables
    validate_permissions("create_edit.emails") ? '' : return
    @email_alert = EmailAlert.find(params[:id])

    if @email_alert.update(active: params[:active])
      render json: @email_alert
    else
      render json: @email_alert.errors, status: :unprocessable_entity
    end
  end

  def update_email_alert_autosend
    @email_alert = EmailAlert.find(params[:id])

    if @email_alert.update(auto_send: params[:auto_send])
      render json: @email_alert
    else
      render json: @email_alert.errors, status: :unprocessable_entity
    end
  end

  def assign_stages
    ContactStageEmail.where(email_alert_id: params[:id]).delete_all

    params[:stages].each do |stage|
      stage_email = ContactStageEmail.create(contact_stage_id: stage, email_alert_id: params[:id])
    end

    head :ok
  end

  def assign_stage
    stage_email = ContactStageEmail.new(contact_stage_id: params[:stage_id], email_alert_id: params[:email_id])

    if stage_email.save
      stage_name = stage_email.contact_stage.stage || stage_email.contact_stage.sub_stage
      render json: {stage_id: stage_email.contact_stage.id, stage: stage_name, email_id: stage_email.email_alert_id}.to_json
    else
      render json: stage_email.errors, status: :unprocessable_entity
    end
  end

  def remove_stage
    stage_email = ContactStageEmail.find_by(contact_stage_id: params[:stage_id], email_alert_id: params[:email_id])
    stage_email.destroy
    redirect_to :back
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_email_alert
    @email_alert = EmailAlert.find_by_id_and_account_id(params[:id], @current_user.account_id)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def email_alert_params
    params.require(:email_alert).permit(
        :description,
        :template,
        :active,
        :account_id,
        :stage_num
    )
  end
end
