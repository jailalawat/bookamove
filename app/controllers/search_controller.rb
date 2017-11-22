class SearchController < ApplicationController
  before_filter :current_user

  def index
    @options = Search.search(params, @current_user.account_id)
    @search = params[:search]
    @movers = @options[:move_posted]
    @trucks = @options[:trucks]
  end
end