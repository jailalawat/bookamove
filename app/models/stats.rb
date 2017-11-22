class Stats < ActiveRecord::Base
  def self.stats_staff(params, user)
    year = params[:year].present? ? params[:year].to_i : Time.now.year
    month = params[:month].present? ? Date::MONTHNAMES.index(params[:month]) : Time.now.month
    type = params[:type].present? ? params[:type] : 'year'
    if type == 'year'
      start_date = Date.new(year, 1).beginning_of_month
      end_date = Date.new(year, 12).end_of_month
    end
    if type == 'month'
      start_date = Date.new(year, month).at_beginning_of_month
      end_date = Date.new(year, month).end_of_month
    end
    sql_posted = "select mv.id as `move_id`, ms.stage, ms.sub_stage,
    msea.contact_stage_id, msea.updated_at
    from move_records as mv
    inner join move_status_email_alerts msea on mv.id = msea.move_record_id
    inner join contact_stages ms on ms.id = msea.contact_stage_id
    where mv.account_id = ?
    AND msea.user_id = ?
    AND msea.updated_at between ? and ?"
    all_records = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(
            :sanitize_sql_array,
            [
                sql_posted,
                user.account_id,
                user.id,
                start_date,
                end_date
            ]
        )
    )
    if type == 'year'
      return getCommissionsByYear(all_records, user)
    end
    getCommissionsByMonth(all_records, user)
  end

  def self.stats_owner(params, user)
    year = params[:year].present? ? params[:year].to_i : Time.now.year
    month = params[:month].present? ? Date::MONTHNAMES.index(params[:month]) : Time.now.month
    type = params[:type].present? ? params[:type] : 'year'
    if type == 'year'
      start_date = Date.new(year, 1).beginning_of_month
      end_date = Date.new(year, 12).end_of_month
    end
    if type == 'month'
      start_date = Date.new(year, month).at_beginning_of_month
      end_date = Date.new(year, month).end_of_month
    end
    sql_posted = "select mv.id as `move_id`,ms.stage, ms.sub_stage,
    msea.contact_stage_id, msea.updated_at
    from move_records as mv
    inner join move_status_email_alerts msea on mv.id = msea.move_record_id
    inner join contact_stages ms on ms.id = msea.contact_stage_id
    where mv.account_id = ?
    AND msea.updated_at between ? and ?"
    all_records = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(
            :sanitize_sql_array,
            [
                sql_posted,
                user.account_id,
                start_date,
                end_date
            ]
        )
    )
    if type == 'year'
      return getCommissionsByYear(all_records, user)
    end
    getCommissionsByMonth(all_records, user)
  end

  private

  def self.getCommissionsByYear(all_records, user)
    complete_id = ContactStage.where(account_id: user.account_id, stage: "Complete").pluck(:id).first
    cancel_id = ContactStage.where(account_id: user.account_id, sub_stage: "Cancel").pluck(:id).first
    follow_up_id = ContactStage.where(account_id: user.account_id, sub_stage: "Follow Up").pluck(:id).first
    receive_id = ContactStage.where(account_id: user.account_id, sub_stage: "Receive").pluck(:id).first
    unable_id = ContactStage.where(account_id: user.account_id, sub_stage: "Unable").pluck(:id).first
    submit_id = ContactStage.where(account_id: user.account_id, sub_stage: "Submit").pluck(:id).first
    post_id = ContactStage.where(account_id: user.account_id, sub_stage: "Post").pluck(:id).first

    records_by_months = all_records.group_by do |t|
      t['updated_at'].beginning_of_month
    end
    records = {}
    records_by_months.keys.sort.each do |month|
      current_month = month.strftime('%B')
      records[current_month] = nil
      commissions = 0
      completed = 0
      canceled = 0
      follow_up = 0
      receive = 0
      unable = 0
      submit = 0
      post = 0
      count_commissions = 0
      percentage = 0
      type_commissions = []
      records_by_months[month].each do |move|
        x_stage = move['stage'] || move['sub_stage']
        table = ActiveRecord::Base.connection.exec_query("show tables like '" +
                                                             x_stage.downcase + "_commission_move_records'").count
        completed += move['contact_stage_id'] == complete_id ? 1 : 0
        canceled += move['contact_stage_id'] == cancel_id ? 1 : 0
        follow_up += move['contact_stage_id'] == follow_up_id ? 1 : 0
        receive += move['contact_stage_id'] == receive_id ? 1 : 0
        unable += move['contact_stage_id'] == unable_id ? 1 : 0
        submit += move['contact_stage_id'] == submit_id ? 1 : 0
        post += move['contact_stage_id'] == post_id ? 1 : 0
        count_commissions += 1
        next unless table > 0
        sql_dynamic = "select cm.total_commission , cm.move_record_id
        from " + x_stage.downcase +
            "_commission_move_records as cm
        where cm.account_id = ? AND cm.move_record_id  = ?"
        result = ActiveRecord::Base.connection.exec_query(
            ActiveRecord::Base.send(
                :sanitize_sql_array,
                [sql_dynamic, user.account_id, move['move_id'].to_i])
        )
        num = result.map { |e| e['total_commission'] }[0]
        commissions += num.present? ? num : 0
        type_commissions << x_stage
      end

      booked = type_commissions.inject(Hash.new(0)) { |h, e| h[e] += 1; h }['Book']
      quote = type_commissions.inject(Hash.new(0)) { |h, e| h[e] += 1; h }['Quote']

      percentage = booked.to_f / (quote.to_f - canceled.to_f).round(2)
      percentage = 100 - ((percentage.to_s == '-Infinity' || percentage.to_s == 'NaN' || percentage.to_s == 'Infinity') ? 0.0 : percentage)

      records[current_month] = {'total_commission' => commissions.round(2),
                                'type_commissions' => type_commissions.inject(Hash.new(0)) { |h, e| h[e] += 1; h },
                                'percentage' => percentage, 'canceled' => canceled, 'follow_up' => follow_up,
                                'receive' => receive, 'unable' => unable, 'submit' => submit,
                                'post' => post, 'completed' => completed, 'month_value' => month}
    end
    records
  end

  def self.getCommissionsByMonth(all_records, user)
    complete_id = ContactStage.where(account_id: user.account_id, stage: "Complete").pluck(:id).first
    cancel_id = ContactStage.where(account_id: user.account_id, sub_stage: "Cancel").pluck(:id).first
    follow_up_id = ContactStage.where(account_id: user.account_id, sub_stage: "Follow Up").pluck(:id).first
    receive_id = ContactStage.where(account_id: user.account_id, sub_stage: "Receive").pluck(:id).first
    unable_id = ContactStage.where(account_id: user.account_id, sub_stage: "Unable").pluck(:id).first
    submit_id = ContactStage.where(account_id: user.account_id, sub_stage: "Submit").pluck(:id).first
    post_id = ContactStage.where(account_id: user.account_id, sub_stage: "Post").pluck(:id).first

    records_by_days = all_records.group_by do |t|
      t['updated_at'].beginning_of_day
    end
    records = {}
    records_by_days.keys.sort.each do |day|
      current_day = day.strftime('%e')
      records[current_day] = nil
      commissions = 0
      completed = 0
      canceled = 0
      follow_up = 0
      receive = 0
      unable = 0
      submit = 0
      post = 0
      percentage = 0
      count_commissions = records_by_days[day].count
      type_commissions = []
      records_by_days[day].each do |move|
        x_stage = move['stage'] || move['sub_stage']
        table = ActiveRecord::Base.connection.exec_query(
            "show tables like '" +
                x_stage.downcase + "_commission_move_records'").count
        completed += move['contact_stage_id'] == complete_id ? 1 : 0
        canceled += move['contact_stage_id'] == cancel_id ? 1 : 0
        follow_up += move['contact_stage_id'] == follow_up_id ? 1 : 0
        receive += move['contact_stage_id'] == receive_id ? 1 : 0
        unable += move['contact_stage_id'] == unable_id ? 1 : 0
        submit += move['contact_stage_id'] == submit_id ? 1 : 0
        post += move['contact_stage_id'] == post_id ? 1 : 0
        next unless table > 0
        sql_dynamic = "select cm.total_commission , cm.move_record_id
          from " + x_stage.downcase +
            "_commission_move_records as cm
          where cm.account_id = ? AND cm.move_record_id  = ?"
        result = ActiveRecord::Base.connection.exec_query(
            ActiveRecord::Base.send(
                :sanitize_sql_array,
                [sql_dynamic, user.account_id, move['move_id'].to_i])
        )
        num = result.map { |e| e['total_commission'] }[0]
        commissions += num.present? ? num : 0
        type_commissions << x_stage
      end

      booked = type_commissions.inject(Hash.new(0)) { |h, e| h[e] += 1; h }['Book']
      quote = type_commissions.inject(Hash.new(0)) { |h, e| h[e] += 1; h }['Quote']

      percentage = booked.to_f / (quote.to_f - canceled.to_f).round(2)
      percentage = 100 - ((percentage.to_s == '-Infinity' || percentage.to_s == 'NaN' || percentage.to_s == 'Infinity') ? 0.0 : percentage)

      records[current_day] = {'total_commission' => commissions.round(2),
                              'type_commissions' => type_commissions.inject(Hash.new(0)) { |h, e| h[e] += 1; h },
                              'percentage' => percentage, 'canceled' => canceled, 'follow_up' => follow_up,
                              'receive' => receive, 'unable' => unable, 'submit' => submit,
                              'post' => post, 'completed' => completed, 'month_value' => day}
    end
    records
  end
end
