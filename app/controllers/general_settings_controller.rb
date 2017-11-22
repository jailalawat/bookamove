class GeneralSettingsController < ApplicationController
  before_filter :current_user

  def index
    @general_settings = GeneralSetting.where(account_id: @current_user.account_id)
  end

  def update
    setting = GeneralSetting.find(params[:id])
    if setting.update(settings_params)
      render json: {updated: "ok"}
    else
      render json: account.errors, status: :unprocessable_entity
    end
  end

  private
  def settings_params
    params.permit(:id, :value, :active)
  end

end