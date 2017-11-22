class MoveSectionsController < ApplicationController
  before_filter :current_user

  def view_lead
    #validate_permissions("show.lead_report") ? '' : return
    @title_page = "Lead Report"
    render template: "move_sections/lead", locals: {type_report: "lead"}
  end

  def view_quote
    #validate_permissions("show.quote_report") ? '' : return
    @title_page = "Quote Report"
    render template: "move_sections/sections", locals: {type_report: "quote"}
  end

  def view_book
    #validate_permissions("show.book_report") ? '' : return
    @title_page = "Book Report"
    render template: "move_sections/sections", locals: {type_report: "book"}
  end

  def view_dispatch
    #validate_permissions("show.dispatch_report") ? '' : return
    @title_page = "Dispatch Report"
    render template: "move_sections/sections", locals: {type_report: "dispatch"}
  end

  def view_complete
    #validate_permissions("show.complete_report") ? '' : return
    @title_page = "Complete Report"
    render template: "move_sections/sections", locals: {type_report: "complete"}
  end

  def fill_table_lead_report
    #validate_permissions("show.lead_report") ? '' : return
    all_move_record = []
    response = MoveSection.lead_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], params[:length], params[:start], @current_user.account_id)
    response[:move_posted].each do |move|
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
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record} }
    end
  end

  def fill_table_quote_report
    #validate_permissions("show.quote_report") ? '' : return
    all_move_record = []
    response = MoveSection.quote_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], params[:length], params[:start], @current_user.account_id)
    response[:move_posted].each do |move|
      all_move_record.push({
                               move_id: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["move_id"].to_s + '</a>',
                               author: move["author"],
                               stage: move["stage"],
                               comments: move["comments"],
                               date: move["date"].strftime("%d/%m/%Y")
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record} }
    end
  end

  def fill_table_complete_report
    #validate_permissions("show.complete_report") ? '' : return
    all_move_record = []
    response = MoveSection.complete_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], params[:length], params[:start], @current_user.account_id)
    response[:move_posted].each do |move|
      all_move_record.push({
                               move_id: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["move_id"].to_s + '</a>',
                               author: move["author"],
                               stage: move["stage"],
                               comments: move["comments"],
                               date: move["date"].strftime("%d/%m/%Y")
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record} }
    end
  end

  def fill_table_dispatch_report
    #validate_permissions("show.dispatch_report") ? '' : return
    all_move_record = []
    response = MoveSection.dispatch_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], params[:length], params[:start], @current_user.account_id)
    response[:move_posted].each do |move|
      all_move_record.push({
                               move_id: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["move_id"].to_s + '</a>',
                               author: move["author"],
                               stage: move["stage"],
                               comments: move["comments"],
                               date: move["date"].strftime("%d/%m/%Y")
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record} }
    end
  end

  def fill_table_book_report
    #validate_permissions("show.book_report") ? '' : return
    all_move_record = []
    response = MoveSection.book_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], params[:length], params[:start], @current_user.account_id)
    response[:move_posted].each do |move|
      all_move_record.push({
                               move_id: '<a href="' + edit_move_record_path(move["move_id"]) + '" target="_blank">' + move["move_id"].to_s + '</a>',
                               author: move["author"],
                               stage: move["stage"],
                               comments: move["comments"],
                               date: move["date"].strftime("%d/%m/%Y")
                           })
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record} }
    end
  end
end