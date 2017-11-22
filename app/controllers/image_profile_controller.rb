class ImageProfileController < ApplicationController
  before_filter :current_user

  def create
    respond_to do |format|
      name = (rand() * 4).to_s+'_'+Time.now.to_i.to_s + '_' + params[:upload][:file].original_filename
      @ImageProfile = ImageProfile.new
      @ImageProfile.user_id = params[:id].present? ? params[:id] : @current_user.id
      @ImageProfile.file = upload_bucket_file(params[:upload][:file], name, 'mmo-profile-image-dev')
      @ImageProfile.account_id = @current_user.account_id
      @ImageProfile.name = name
      @ImageProfile.save
      format.json { render json: @ImageProfile }
    end
  end

  def destroy
    @upload = ImageProfile.find(params[:img_ID])
    delete_uploaded_file(@upload.name, 'mmo-profile-image-dev')
    @upload.destroy
    respond_to do |format|
      format.html { redirect_to calendar_truck_groups_url, notice: 'Image was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end