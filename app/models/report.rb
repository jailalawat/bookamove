class Report < ActiveRecord::Base
  def self.post_report(params, account_id)
    invoice_id = ContactStage.where(account_id: account_id, sub_stage: "Invoice").pluck(:id).first
    post_id = ContactStage.where(account_id: account_id, sub_stage: "Post").pluck(:id).first

    add_sql = ''
    if (params[:report_calendar_start].present? && params[:report_calendar_end].present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + params[:report_calendar_start] + "' AND '" + params[:report_calendar_end] + "' "
    end
    if !params[:search]["value"].blank?
      term = params[:search]["value"]
      add_sql += " AND (c.name like '%" + term + "%' or mv.id like '%" + term + "%' or mv.created_at like '%" + term + "%' or t.description like '%" + term + "%' or u.name like '%" + term + "%' or ms.description like '%" + term + "%' or mv.total_cost like '%" + term + "%')"
    end
    column_to_order = params[:order]["0"]["column"]
    type_to_reorder = params[:order]["0"]["dir"]
    column_reorder = params[:columns][column_to_order]["data"]
    sql_posted = "select c.name as `name`, mv.id as `move_id`, mv.created_at as `date`,
						(select ct.name
						from trucks tt
						inner join list_truck_groups lt on tt.id = lt.truck_id
						inner join calendar_truck_groups ct on lt.calendar_truck_group_id = ct.id
						where tt.id = t.id) as `group` ,t.description as `truck`, u.name as `author`, ms.description as `source`, mv.total_cost as `total_cost`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join trucks t on mt.truck_id = t.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ?  AND
						mv.id not in(
									select move_record_id from move_status_email_alerts where contact_stage_id = ?
									)" +
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder

    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,

                                [sql_posted, invoice_id, post_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, invoice_id, post_id, account_id, params[:length].to_i, params[:start].to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

  def self.source_report(params, account_id)
    add_sql = ''
    if (params[:report_calendar_start].present? && params[:report_calendar_end].present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + params[:report_calendar_start] + "' AND '" + params[:report_calendar_end] + "' "
    end
    if !params[:search]["value"].blank?
      term = params[:search]["value"]
      add_sql += " AND (c.name like '%" + term + "%' or mv.id like '%" + term + "%' or mv.created_at like '%" + term + "%' or t.description like '%" + term + "%' or u.name like '%" + term + "%' or ms.description like '%" + term + "%' or mv.total_cost like '%" + term + "%')"
    end
    column_to_order = params[:order]["0"]["column"]
    type_to_reorder = params[:order]["0"]["dir"]
    column_reorder = params[:columns][column_to_order]["data"]
    sql_posted = "select c.name as `name`, mv.id as `move_id`, mv.created_at as `date`, (select ct.name
						from trucks tt
						inner join list_truck_groups lt on tt.id = lt.truck_id
						inner join calendar_truck_groups ct on lt.calendar_truck_group_id = ct.id
						where tt.id = t.id) as `group` ,t.description as `truck`, u.name as `author`, mr.description as `source`, mv.total_cost as `total_cost`
						from move_records mv
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_referrals mr on mv.move_referral_id = mr.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join trucks t on mt.truck_id = t.id
						inner join users u on mv.user_id = u.id
						where mv.account_id = ? " +
        add_sql +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder

    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, account_id, params[:length].to_i, params[:start].to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

  def self.card_batch_report(params, account_id)
    post_id = ContactStage.where(account_id: account_id, sub_stage: "Post").pluck(:id).first

    add_sql = ''
    if (params[:report_calendar_start].present? && params[:report_calendar_end].present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + params[:report_calendar_start] + "' AND '" + params[:report_calendar_end] + "' "
    end
    if !params[:search]["value"].blank?
      term = params[:search]["value"]
      add_sql += " AND (c.name like '%" + term + "%' or mv.id like '%" + term + "%' or mv.created_at like '%" + term + "%' or t.description like '%" + term + "%' or u.name like '%" + term + "%' or ms.description like '%" + term + "%' or mv.total_cost like '%" + term + "%')"
    end
    column_to_order = params[:order]["0"]["column"]
    type_to_reorder = params[:order]["0"]["dir"]
    column_reorder = params[:columns][column_to_order]["data"]
    sql_posted = "select c.name as `name`, mv.id as `move_id`, mv.created_at as `date`,
	  					(select ct.name
						from trucks tt
						inner join list_truck_groups lt on tt.id = lt.truck_id
						inner join calendar_truck_groups ct on lt.calendar_truck_group_id = ct.id
						where tt.id = t.id) as `group` ,t.description as `truck`, u.name as `author`, ms.description as `source`, mv.total_cost as `total_cost`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join move_record_payments mp on mv.id = mp.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join trucks t on mt.truck_id = t.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ?
						AND mp.type_payment in ('visa','mastercard','discover') " +
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder

    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, post_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, post_id, account_id, params[:length].to_i, params[:start].to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}

  end
end
