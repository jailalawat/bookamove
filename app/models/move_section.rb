class MoveSection < ActiveRecord::Base

  def self.lead_report(report_calendar_start, report_calendar_end, search, order, columns, length, start, account_id)
    lead_id = ContactStage.where(account_id: account_id, stage: "Lead").pluck(:id).first

    add_sql = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search["value"].blank?
      term = search["value"]
      add_sql += " AND (c.name like '%" + term + "%' or mv.id like '%" + term + "%' or mv.created_at like '%" +
          term + "%' or t.description like '%" + term + "%' or u.name like '%"
      +term + "%' or ms.description like '%" + term + "%' or mv.total_cost like '%" + term + "%')"
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
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
						where msea.contact_stage_id = ?"+
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, lead_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, lead_id, account_id, length.to_i, start.to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

  def self.quote_report(report_calendar_start, report_calendar_end, search_param, order, columns, length, start, account_id)
    quote_id = ContactStage.where(account_id: account_id, sub_stage: "Quote").pluck(:id).first

    add_sql = ''
    search = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      search += ") tmp where move_id like '%" + term + "%' or author like '%" + term + "%' or stage like '%" + term + "%' or comments like '%" + term + "%' or date like '%" + term + "%'"
      sql_posted = 'select * from ('
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select mv.id as `move_id`, md.move_date as `date`, u.name as `author`, mv.contract_note as `comments`, (select smses.sub_stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1) as `stage`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ? "+
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, quote_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, quote_id, account_id, length.to_i, start.to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

  def self.complete_report(report_calendar_start, report_calendar_end, search_param, order, columns, length, start, account_id)
    complete_id = ContactStage.where(account_id: account_id, stage: "Complete").pluck(:id).first

    add_sql = ''
    search = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      search += ") tmp where move_id like '%" + term + "%' or author like '%" + term + "%' or stage like '%" + term + "%' or comments like '%" + term + "%' or date like '%" + term + "%'"
      sql_posted = 'select * from ('
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select mv.id as `move_id`, md.move_date as `date`, u.name as `author`, mv.contract_note as `comments`, (select smses.stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1) as `stage`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ? "+
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, complete_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, complete_id, account_id, length.to_i, start.to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

  def self.dispatch_report(report_calendar_start, report_calendar_end, search_param, order, columns, length, start, account_id)
    dispatch_id = ContactStage.where(account_id: account_id, sub_stage: "Dispatch").pluck(:id).first
    complete_id = ContactStage.where(account_id: account_id, stage: "Complete").pluck(:id).first

    add_sql = ''
    search = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      search += ") tmp where move_id like '%" + term + "%' or author like '%" + term + "%' or stage like '%" + term + "%' or comments like '%" + term + "%' or date like '%" + term + "%'"
      sql_posted = 'select * from ('
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select mv.id as `move_id`, md.move_date as `date`, u.name as `author`, mv.contract_note as `comments`, (select smses.sub_stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1) as `stage`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ? AND
						mv.id not in(
							select move_record_id from move_status_email_alerts where contact_stage_id = ?
						)"+
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, dispatch_id, complete_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, dispatch_id, complete_id, account_id, length.to_i, start.to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

  def self.book_report(report_calendar_start, report_calendar_end, search_param, order, columns, length, start, account_id)
    book_id = ContactStage.where(account_id: account_id, stage: "Book").pluck(:id).first
    dispatch_id = ContactStage.where(account_id: account_id, sub_stage: "Dispatch").pluck(:id).first

    add_sql = ''
    search = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      search += ") tmp where move_id like '%" + term + "%' or author like '%" + term + "%' or stage like '%" + term + "%' or comments like '%" + term + "%' or date like '%" + term + "%'"
      sql_posted = 'select * from ('
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select mv.id as `move_id`, md.move_date as `date`, u.name as `author`, mv.contract_note as `comments`, (select smses.stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1) as `stage`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ? AND
						mv.id not in(
							select move_record_id from move_status_email_alerts where contact_stage_id = ?
						)"+
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, book_id, dispatch_id, account_id])
    ).count
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, book_id, dispatch_id, account_id, length.to_i, start.to_i])
    )
    return {move_posted: move_posted, count_move_posted: count_move_posted}
  end

end
