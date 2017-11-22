class ContactStagesController < ApplicationController
  before_filter :current_user

  def create
    validate_permissions("configure.contract") ? '' : return
    last_sub_stage = ContactStage.where(account_id: @current_user.account_id, stage_num: params[:stage_num], stage: nil).pluck(:sub_stage_num, :position).last
    @sub_stage = ContactStage.new(account_id: @current_user.account_id, stage_num: params[:stage_num], sub_stage: params[:sub_stage_name], sub_stage_num: (last_sub_stage[0]+1), position: (last_sub_stage[1]+1))

    if @sub_stage.save
      render json: @sub_stage
    else
      render json: @sub_stage.errors, status: :unprocessable_entity
    end
  end

  def update
    validate_permissions("configure.contract") ? '' : return
    @sub_stage = ContactStage.where(id: params[:id], account_id: @current_user.account_id)

    if @sub_stage.update(stage_num: params[:stage_num], sub_stage: params[:sub_stage_name])
      render json: @sub_stage
    else
      render json: @sub_stage.errors, status: :unprocessable_entity
    end
  end

  def update_substage_positions
    validate_permissions("configure.contract") ? '' : return
    params[:subs].each_with_index do |sub, index|
      ContactStage.update(sub, position: index)
    end

    head :ok
  end

  def update_substage_enables
    validate_permissions("configure.contract") ? '' : return
    @sub_stage = ContactStage.find(params[:id])

    if @sub_stage.update(active: params[:active])
      # if dispatch stage disabled, move driver emails to book stage
      if @sub_stage.sub_stage == "Dispatch"
        driver_emails = EmailAlert.where(description: "Email Receive").or(EmailAlert.where(description: "Receive 2")).where(account_id: 2) || []
        book_stage = ContactStage.find_by(stage: "Book", account_id: @current_user.account_id)

        # remove from dispatch and attach to book
        if not @sub_stage.active
          driver_emails.each do |email|
            ContactStageEmail.find_by(contact_stage_id: @sub_stage.id, email_alert_id: email.id).delete
            ContactStageEmail.create(contact_stage_id: book_stage.id, email_alert_id: email.id)
          end
        # remove from book and attach to dispatch
        else
          driver_emails.each do |email|
            ContactStageEmail.find_by(contact_stage_id: book_stage.id, email_alert_id: email.id).delete
            ContactStageEmail.create(contact_stage_id: @sub_stage.id, email_alert_id: email.id)
          end
        end
      end

      render json: @sub_stage
    else
      render json: @sub_stage.errors, status: :unprocessable_entity
    end
  end

  def attach_emails
    validate_permissions("configure.contract") ? '' : return
    ContactStageEmail.where(contact_stage_id: params[:id]).delete_all

    if params[:emails].present?
      params[:emails].each do |email|
        ContactStageEmail.create(contact_stage_id: params[:id], email_alert_id: email)
      end
    end

    head :ok
  end

  def destroy
    validate_permissions("configure.contract") ? '' : return
    @sub_stage = ContactStage.find(params[:id])
    @sub_stage.destroy
  end

end