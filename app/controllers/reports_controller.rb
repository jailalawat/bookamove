class ReportsController < ApplicationController
  before_filter :current_user
  before_action :get_cal_range, only: [:view_post, :view_source, :view_card_batch]

  def view_post
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "Post Report"
    render template: "reports/report", locals: {type_report: "post"}
  end

  def view_source
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "Source Report"
    render template: "reports/report", locals: {type_report: "source"}
  end

  def view_card_batch
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "Card Batch Report"
    render template: "reports/report", locals: {type_report: "card_batch"}
  end

  def fill_table_post_report
    validate_permissions("create_edit.reports") ? '' : return
    all_move_record = []
    move_posted = Report.post_report(params, @current_user.account_id)
    move_posted[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["name"] + '</a>',
                               move_id: move["move_id"],
                               date: move["date"].strftime("%d/%m/%Y"),
                               group: move["group"],
                               truck: move["truck"],
                               author: move["author"],
                               source: move["source"],
                               total_cost: move["total_cost"]
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: move_posted[:count_move_posted], recordsFiltered: move_posted[:count_move_posted], data: all_move_record} }
    end
  end

  def fill_table_source_report
    #validate_permissions("show.source_report") ? '' : return
    all_move_record = []
    move_posted = Report.source_report(params, @current_user.account_id)
    move_posted[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["name"] + '</a>',
                               move_id: move["move_id"],
                               date: move["date"].strftime("%d/%m/%Y"),
                               group: move["group"],
                               truck: move["truck"],
                               author: move["author"],
                               source: move["source"],
                               total_cost: move["total_cost"]
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: move_posted[:count_move_posted], recordsFiltered: move_posted[:count_move_posted], data: all_move_record} }
    end

  end

  def fill_table_card_batch_report
    #validate_permissions("show.card_batch_report") ? '' : return
    all_move_record = []
    move_posted = Report.card_batch_report(params, @current_user.account_id)
    move_posted[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["name"] + '</a>',
                               move_id: move["move_id"],
                               date: move["date"].strftime("%d/%m/%Y"),
                               group: move["group"],
                               truck: move["truck"],
                               author: move["author"],
                               source: move["source"],
                               total_cost: move["total_cost"]
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: move_posted[:count_move_posted], recordsFiltered: move_posted[:count_move_posted], data: all_move_record} }
    end
  end

  def get_cal_range
    cal_range = GeneralSetting.where(account_id: @current_user.account_id, type: "calendar_range").limit(1)
    @calendar_range = (not cal_range.blank?) ? cal_range[0].value : 5
  end

end