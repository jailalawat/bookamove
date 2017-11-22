class StatsController < ApplicationController
  before_filter :current_user

  def view_stats
    @year = params[:year].present? ? params[:year] : Time.now.year
    @title_page = 'Stats - ' + @year.to_s
    render template: 'stats/index', locals: {type_report: 'stats'}
  end

  def fill_table_stats
    all_move_record = []
    if validate_special_permission("show.stats_by_account")
      move_record = params[:stats_user].blank? ? Stats.stats_owner(params, @current_user) : Stats.stats_staff(params, User.find_by_id(params[:stats_user]))
    else
      user = params[:stats_user].blank? ? @current_user : User.find_by_id(params[:stats_user])
      move_record = Stats.stats_staff(params, user)
    end

    move_record.each do |key, value|
      all_move_record.push(
          month: params['type'] == 'year' ? '<a class="button-link" data-month=' + key + '>' + key + '</a>' : key,
          lead: value['type_commissions']['Lead'].present? ? value['type_commissions']['Lead'] : 0,
          quote: value['type_commissions']['Quote'].present? ? value['type_commissions']['Quote'] : 0,
          book: value['type_commissions']['Book'].present? ? value['type_commissions']['Book'] : 0,
          dispatch: value['type_commissions']['Dispatch'].present? ? value['type_commissions']['Dispatch'] : 0,
          confirm: value['type_commissions']['Confirm'].present? ? value['type_commissions']['Confirm'] : 0,
          invoice: value['type_commissions']['Invoice'].present? ? value['type_commissions']['Invoice'] : 0,
          aftercare: value['type_commissions']['Aftercare'].present? ? value['type_commissions']['Aftercare'] : 0,
          canceled: value['canceled'].to_s,
          follow_up: value['follow_up'].to_s,
          receive: value['receive'].to_s,
          unable: value['unable'].to_s,
          submit: value['submit'].to_s,
          post: value['post'].to_s,
          completed: value['completed'].to_s,
          percentage: value['percentage'].to_s + '%',
          total_commission: '$' + value['total_commission'].to_s
      )
    end
    respond_to do |format|
      format.json { render json: {data: all_move_record} }
    end
  end
end
