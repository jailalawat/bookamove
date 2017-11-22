class ReviewLinksController < ApplicationController
  before_filter :current_user

  def create
    link = ReviewLink.new(link_params)
    link.account_id = @current_user.account_id

    if link.save
      redirect_to "/calendar_truck_groups/#{link.calendar_truck_group_id}/edit#links"
    end
  end

  def destroy
    link = ReviewLink.find_by(id: params["id"], account_id: @current_user.account_id)
    link.destroy
    redirect_to "/calendar_truck_groups/#{params[:calendar_truck_group_id]}/edit#links"
  end

  private

  def link_params
    params.require(:review_link).permit(:icon, :name, :link_url, :calendar_truck_group_id)
  end

end
