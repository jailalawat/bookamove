class StatementController < ApplicationController
  before_filter :current_user

  def view_statement
    @title_page = 'Statement'
    render template: 'statement/index', locals: {type_report: 'statement'}
  end

  def fill_table_statement
    all_move_record = []
    total = 0
    move_record = Statement.statement(params, @current_user.account_id, @current_user.id)
    move_record[:move_record].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["name"] + '</a>',
                               move_stages: move["move_stages"],
                               date: move["date"].strftime("%d/%m/%Y"),
                               total_cost: move["total_cost"].round(2),
                           })
      total += move['total_cost'].round(2)
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: move_record[:count_move_record], recordsFiltered: move_record[:count_move_record], data: all_move_record, total: total} }
    end
  end
end
