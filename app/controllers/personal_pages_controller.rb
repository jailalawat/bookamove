class PersonalPagesController < ApplicationController
  before_filter :current_user
  before_action :get_cal_range, only: [:view_lead, :view_quote, :view_book, :view_complete, :view_review_responses]

  def view_lead
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "My Moves"
    @page_title = "<i class='icon-file-text blank3 blue-text'></i><span id='pTitle_text'>Leads report<span>".html_safe
  end

  def view_quote
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "My Moves"
    @page_title = "<i class='icon-file-text blank3 blue-text'></i><span id='pTitle_text'>Quotes report<span>".html_safe
  end

  def view_book
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "My Moves"
    @page_title = "<i class='icon-file-text blank3 blue-text'></i><span id='pTitle_text'>Booked report<span>".html_safe
  end

  def view_complete
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "My Moves"
    @page_title = "<i class='icon-file-text blank3 blue-text'></i><span id='pTitle_text'>Completed report<span>".html_safe
  end

  def view_review_responses
    validate_permissions("create_edit.reports") ? '' : return
    @title_page = "My Moves"
    @page_title = "<i class='icon-file-text blank3 blue-text'></i><span id='pTitle_text'>Review Responses report<span>".html_safe
  end

  def fill_table_complete_book
    all_move_record = []
    all_groups = []
    response = PersonalPage.complete_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], @current_user.account_id, @current_user.id, params[:state_filter], params[:group_filter])
    response[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '">' + move["name"] + '</a>',
                               completed_date: move["completed_date"].strftime("%Y/%m/%d"),
                               group: move["group"],
                               move_date: move["move_date"].strftime("%Y/%m/%d"),
                               group: move["group"],
                               stage: move["stage"] || move["sub_stage"],
                               # status: (move["submitted"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' S &nbsp;'+ (move["invoiced"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' I &nbsp;'+ (move["posted"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' P &nbsp;'+ (move["aftercared"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' A &nbsp;',
                               notes: message_icon(move["message_type"]) +' '+ (move["message_author"].to_s) +' '+ (move["message_time"] == nil ? "" : move["message_time"].strftime("%l:%M %P %b %d")) +' '+ (move["message_subject"].to_s)
                           })
      all_groups.push(move["group"])
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record, groups: all_groups.uniq} }
    end
  end

  def fill_table_move_book
    all_move_record = []
    all_trucks = []
    all_groups = []
    all_bookers = []
    all_drivers = []
    response = PersonalPage.book_report(params[:search], params[:order], params[:columns], @current_user.account_id, @current_user.id, params[:state_filter], params[:truck_filter], params[:group_filter], params[:booker_filter], params[:driver_filter])
    response[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '">' + move["name"] + '</a>',
                               created: move["created"].strftime("%Y/%m/%d %l:%M %P"),
                               truck_name: move["truck_name"],
                               stage: (move["stage"] || move["sub_stage"]),
                               move_date: move["move_date"].strftime("%Y/%m/%d %l:%M %P"),
                               booker: move["booker"],
                               driver: move["driver"],
                               # status: (move["dispatched"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' D &nbsp;'+ (move["confirmed"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' C &nbsp;'+ (move["recieved"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' R &nbsp;'+ (move["active"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' A',
                               status: "<span class='small'>Confirmed: #{(move["confirmed"].nil? ? "<i class='fa fa-times small_icon icon-red pull-right' aria-hidden='true'></i>" : "<i class='fa fa-check-circle small_icon icon-green pull-right' aria-hidden='true'></i>")}<br/>"+
                                   "Received: #{(move["recieved"].nil? ? "<i class='fa fa-times small_icon icon-red pull-right' aria-hidden='true'></i>" : "<i class='fa fa-check-circle small_icon icon-green pull-right' aria-hidden='true'></i>")}<br/>"+
                                   "Confirmed 2: #{(move["confirmed2"].nil? ? "<i class='fa fa-times small_icon icon-red pull-right' aria-hidden='true'></i>" : "<i class='fa fa-check-circle small_icon icon-green pull-right' aria-hidden='true'></i>")}<br/>"+
                                   "Confirmed 7: #{(move["confirmed7"].nil? ? "<i class='fa fa-times small_icon icon-red pull-right' aria-hidden='true'></i>" : "<i class='fa fa-check-circle small_icon icon-green pull-right' aria-hidden='true'></i>")}<br/>"+
                                   "Received 2: #{(move["recieved2"].nil? ? "<i class='fa fa-times small_icon icon-red pull-right' aria-hidden='true'></i>" : "<i class='fa fa-check-circle small_icon icon-green pull-right' aria-hidden='true'></i></span>")}",
                               notes: message_icon(move["message_type"]) +' '+ (move["message_author"].to_s) +' '+ (move["message_time"] == nil ? "" : move["message_time"].strftime("%l:%M %P %b %d")) +' '+ (move["message_subject"].to_s)
                           })
      all_trucks.push(move["truck_name"])
      all_groups.push(move["group"])
      all_bookers.push(move["booker"])
      all_drivers.push(move["driver"])
    end
    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record, trucks: all_trucks.uniq, groups: all_groups.uniq, bookers: all_bookers.uniq, drivers: all_drivers.uniq} }
    end
  end

  def fill_table_move_quote
    all_move_record = []
    all_estimators = []
    all_groups = []
    response = PersonalPage.quote_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], @current_user.account_id, @current_user.id, params[:state_filter], params[:estimator_filter], params[:group_filter])
    response[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '">' + move["name"] + '</a>',
                               estimated: move["estimated"].strftime("%Y/%m/%d %l:%M %P"),
                               estimator: move["estimator"],
                               stage: move["stage"],
                               status: (move["unabled"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' U &nbsp;'+ (move["followed_up"] == nil ? '<i class="fa fa-check-circle icon-gray disable"></i>' : '<i class="fa fa-check-circle icon-gray disable icon-green"></i>')+ ' F',
                               notes: message_icon(move["message_type"]) +' '+ (move["message_author"].to_s) +' '+ (move["message_time"] == nil ? "" : move["message_time"].strftime("%l:%M %P %b %d")) +' '+ (move["message_subject"].to_s)
                           })
      all_estimators.push(move["estimator"])
      all_groups.push(move["group"]) if not move["group"].nil?
    end

    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record, estimators: all_estimators.uniq, groups: all_groups.uniq} }
    end
  end

  def fill_table_move_lead
    all_move_record = []
    response = PersonalPage.lead_report(params[:report_calendar_start], params[:report_calendar_end], params[:search], params[:order], params[:columns], @current_user.account_id, @current_user.id)
    response[:move_posted].each do |move|
      all_move_record.push({
                               name: '<a href="' + edit_move_record_path(move["move_id"]) + '">' + move["name"] + '</a>',
                               created: move["created"].strftime("%Y/%m/%d %l:%M %P"),
                               author: move["author"],
                               group: move["group"],
                               stage: (move["stage"].blank? ? move["sub_stage"] : move["stage"]),
                               notes: message_icon(move["message_type"]) +' '+ (move["message_author"].to_s) +' '+ (move["message_time"] == nil ? "" : move["message_time"].strftime("%l:%M %P %b %d")) +' '+ (move["message_subject"].to_s)
                           })
    end

    respond_to do |format|
      format.json { render json: {recordsTotal: response[:count_move_posted], recordsFiltered: response[:count_move_posted], data: all_move_record} }
    end
  end

  def get_first_phone(home_phone, cell_phone, work_phone)
    phone = ""

    if (not work_phone.blank?)
      phone = work_phone
    end
    if (not cell_phone.blank?)
      phone = cell_phone
    end
    if (not home_phone.blank?)
      phone = home_phone
    end

    return phone

  end

  def message_icon(message_type)
    if message_type == "call"
      return '<i class="fa fa-phone-square" aria-hidden="true" style="font-size: 18px !important;"></i>'
    elsif message_type == "email"
      return '<i class="fa fa-envelope" aria-hidden="true"></i>'
    elsif message_type == "external"
      return '<i class="fa fa-user" aria-hidden="true"></i>'
    end

    return ""
  end

  def get_cal_range
    #cal_range = GeneralSetting.where(account_id: @current_user.account_id, type: "calendar_range").limit(1)
    #@calendar_range = (not cal_range.blank?) ? cal_range[0].value : 5
    @calendar_range = 7
  end

end