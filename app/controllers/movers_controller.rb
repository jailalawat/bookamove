class MoversController < ApplicationController
  before_filter :current_user

  def index
  end

  def fill_table_list_move_record_mover
    all_move_record = []
    list_move = Mover.list_move_records(params, @current_user)
    list_move[:list_move].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["name"] + '</a>',
                               date: move["date"].strftime("%d/%m/%Y"),
                               start_time: move["start_time"].strftime("%I:%M %p"),
                               movers: move["movers"]
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: list_move[:count_list_move], recordsFiltered: list_move[:count_list_move], data: all_move_record} }
    end
  end

end
