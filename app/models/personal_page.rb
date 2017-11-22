class PersonalPage < ActiveRecord::Base

  def self.lead_report(report_calendar_start, report_calendar_end, search_param, order, columns, account_id, user_id)
    lead_id = ContactStage.where(account_id: account_id, stage: "Lead").pluck(:id).first

    add_sql = ''
    search = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(mv.created_at) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      search += ") tmp where name like '%" + term + "%' or home_phone like '%" + term + "%' or cell_phone like '%" + term + "%' or work_phone like '%" + term + "%' or email like '%" + term + "%'"
      sql_posted = 'select * from ('
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select * from (select mv.id as `move_id`, mv.created_at as `created`, c.name as `name`, c.home_phone, c.cell_phone, c.work_phone, c.email, md.move_date as `date`, u.name as `author`,
						(select ct.name
						from trucks tt
						inner join list_truck_groups lt on tt.id = lt.truck_id
						inner join calendar_truck_groups ct on lt.calendar_truck_group_id = ct.id
						where tt.id = t.id) as `group`,
						(select smses.stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`id` desc LIMIT 1) as `stage`,
            (select smses.sub_stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`id` desc LIMIT 1) as `sub_stage`,

            (select mmr.subject from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_subject`,
						(select mmr.body from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_body`,
						(select mmr.message_type from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_type`,
						(select mmr.created_at from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_time`,
						(select u.name from messages_move_records mmr inner join users u on mmr.user_id = u.id where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_author`

						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						left join trucks t on mt.truck_id = t.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ?"+
        add_sql +
        " AND mv.account_id = ? " +
        ") AS tbl WHERE tbl.stage = 'Lead' or tbl.sub_stage = 'Prospect' group by move_id ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    move_posted = ActiveRecord::Base.connection.exec_query(ActiveRecord::Base.send(:sanitize_sql_array, [sql_posted, lead_id, account_id]))

    return {move_posted: move_posted}
  end

  def self.quote_report(report_calendar_start, report_calendar_end, search_param, order, columns, account_id, user_id, state_filter, estimator_filter, group_filter)
    quote_id = ContactStage.where(account_id: account_id, sub_stage: "Quote").pluck(:id).first
    follow_up_id = ContactStage.where(account_id: account_id, sub_stage: "Follow Up").pluck(:id).first
    unable_id = ContactStage.where(account_id: account_id, sub_stage: "Unable").pluck(:id).first

    add_sql = ''
    search = ''
    filter1 = ''
    filter2 = ''
    filter3 = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(msea.created_at) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      sql_posted += 'select * from ('
      search += ") tmp where name like '%" + term + "%' or home_phone like '%" + term + "%' or cell_phone like '%" + term + "%' or work_phone like '%" + term + "%' or email like '%" + term + "%'"
    end
    if !state_filter.blank?
      sql_posted += 'select * from ('
      filter1 += ") tmp_filter where " + state_filter
    end
    if !estimator_filter.blank?
      sql_posted += 'select * from ('
      filter2 += ") tmp_filter2 where estimator = '" + estimator_filter + "'"
    end
    if !group_filter.blank?
      sql_posted += 'select * from ('
      filter3 += ") tmp_filter3 where `group` = '" + group_filter + "'"
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select * from (select mv.id as `move_id`, mv.created_at as `created`, c.name as `name`, c.home_phone, c.cell_phone, c.work_phone, c.email, md.move_date, u.name as `author`,
	  				(select ctg.name from calendar_truck_groups ctg where ctg.id = loc.calendar_truck_group_id) as `group`,
						(select smses.sub_stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`id` desc LIMIT 1) as `stage`,
            (select mmr.subject from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_subject`,
						(select mmr.body from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_body`,
            (select mmr.message_type from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_type`,
            (select mmr.created_at from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_time`,
            (select u.name from messages_move_records mmr inner join users u on mmr.user_id = u.id where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_author`,
						(select smsea.created_at from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `estimated`,
						(select u.name from move_status_email_alerts smsea inner join users u on smsea.user_id = u.id where smsea.move_record_id = mv.id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `estimator`,
						(select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `unabled`,
						(select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `followed_up`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join move_record_location_origins mv_loc on mv.id = mv_loc.move_record_id
            inner join locations loc on mv_loc.location_id = loc.id
						inner join users u on mv.user_id = u.id
						where (msea.contact_stage_id = ? or msea.contact_stage_id = ? or msea.contact_stage_id = ?) "+
        add_sql +
        " AND mv.account_id = ? " +
        ") AS tbl WHERE tbl.stage = 'Quote' or tbl.stage = 'Follow up' or tbl.stage = 'Unable' and estimated is not null group by move_id ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = filter1.blank? ? sql_posted : sql_posted + filter1
    sql_posted = filter2.blank? ? sql_posted : sql_posted + filter2
    sql_posted = filter3.blank? ? sql_posted : sql_posted + filter3
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    move_posted = ActiveRecord::Base.connection.exec_query(ActiveRecord::Base.send(:sanitize_sql_array, [sql_posted, quote_id, quote_id, unable_id, follow_up_id, quote_id, follow_up_id, unable_id, account_id]))

    return {move_posted: move_posted}
  end

  def self.complete_report(report_calendar_start, report_calendar_end, search_param, order, columns, account_id, user_id, state_filter, group_filter)
    complete_id = ContactStage.where(account_id: account_id, stage: "Complete").pluck(:id).first
    submit_id = ContactStage.where(account_id: account_id, sub_stage: "Submit").pluck(:id).first
    invoice_id = ContactStage.where(account_id: account_id, sub_stage: "Invoice").pluck(:id).first
    post_id = ContactStage.where(account_id: account_id, sub_stage: "Post").pluck(:id).first
    aftercare_id = ContactStage.where(account_id: account_id, sub_stage: "Aftercare").pluck(:id).first

    add_sql = ''
    search = ''
    filter1 = ''
    filter2 = ''
    sql_posted = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " AND DATE(msea.created_at) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search_param["value"].blank?
      term = search_param["value"]
      sql_posted = 'select * from ('
      search += ") tmp where name like '%" + term + "%' or home_phone like '%" + term + "%' or cell_phone like '%" + term + "%' or work_phone like '%" + term + "%' or email like '%" + term + "%'"
    end
    if !state_filter.blank?
      sql_posted += 'select * from ('
      filter1 += ") tmp_filter where " + state_filter
    end
    if !group_filter.blank?
      sql_posted += 'select * from ('
      filter2 += ") tmp_filter2 where `group` = '" + group_filter + "'"
    end

    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select mv.id as `move_id`, c.name as `name`, c.home_phone, c.cell_phone, c.work_phone, c.email, md.move_date, msea.created_at as completed_date, u.name as `author`,
	  					(select ct.name
						from trucks tt
						inner join list_truck_groups lt on tt.id = lt.truck_id
						inner join calendar_truck_groups ct on lt.calendar_truck_group_id = ct.id
						where tt.id = t.id) as `group`, (select smses.stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`id` desc LIMIT 1) as `stage`,
            (select smses.sub_stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`id` desc LIMIT 1) as `sub_stage`,
            (select mmr.subject from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_subject`,
            (select mmr.body from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_body`,
            (select mmr.message_type from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_type`,
            (select mmr.created_at from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_time`,
            (select u.name from messages_move_records mmr inner join users u on mmr.user_id = u.id where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_author`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `submitted`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `invoiced`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `posted`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `aftercared`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						left join trucks t on mt.truck_id = t.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ? "+
        add_sql +
        " AND mv.account_id = ? " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    sql_posted = search.blank? ? sql_posted : sql_posted + search
    sql_posted = filter1.blank? ? sql_posted : sql_posted + filter1
    sql_posted = filter2.blank? ? sql_posted : sql_posted + filter2
    move_posted = ActiveRecord::Base.connection.exec_query(ActiveRecord::Base.send(:sanitize_sql_array, [sql_posted, submit_id, invoice_id, post_id, aftercare_id, complete_id, account_id]))

    return {move_posted: move_posted}
  end

  def self.book_report(search_param, order, columns, account_id, user_id, state_filter, truck_filter, group_filter, booker_filter, driver_filter)
    book_id = ContactStage.where(account_id: account_id, stage: "Book").pluck(:id).first
    complete_id = ContactStage.where(account_id: account_id, stage: "Complete").pluck(:id).first
    cancel_id = ContactStage.where(account_id: account_id, sub_stage: "Cancel").pluck(:id).first
    dispatch_id = ContactStage.where(account_id: account_id, sub_stage: "Dispatch").pluck(:id).first
    confirm_id = ContactStage.where(account_id: account_id, sub_stage: "Confirm").pluck(:id).first
    receive_id = ContactStage.where(account_id: account_id, sub_stage: "Receive").pluck(:id).first
    confirm2_id = ContactStage.where(account_id: account_id, sub_stage: "Confirm 2").pluck(:id).first
    confirm7_id = ContactStage.where(account_id: account_id, sub_stage: "Confirm 7").pluck(:id).first
    receive2_id = ContactStage.where(account_id: account_id, sub_stage: "Receive 2").pluck(:id).first

    add_sql = ''
    search = ''
    filter1 = ''
    filter2 = ''
    filter3 = ''
    filter4 = ''
    filter5 = ''
    sql_posted = ''

    if !search_param["value"].blank?
      term = search_param["value"]
      sql_posted += 'select * from ('
      search += ") tmp where name like '%" + term + "%' or home_phone like '%" + term + "%' or cell_phone like '%" + term + "%' or work_phone like '%" + term + "%' or email like '%" + term + "%'"
    end
    if !state_filter.blank?
      sql_posted += 'select * from ('
      filter1 += ") tmp_filter where " + state_filter
    end
    if !truck_filter.blank?
      sql_posted += 'select * from ('
      filter2 += ") tmp_filter2 where truck_name = '" + truck_filter + "'"
    end
    if !group_filter.blank?
      sql_posted += 'select * from ('
      filter3 += ") tmp_filter3 where `group` = '" + group_filter + "'"
    end
    if !booker_filter.blank?
      sql_posted += 'select * from ('
      filter4 += ") tmp_filter4 where booker = '" + booker_filter + "'"
    end
    if !driver_filter.blank?
      sql_posted += 'select * from ('
      filter5 += ") tmp_filter5 where driver = '" + driver_filter + "'"
    end

    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted += "select * from (select mv.id as `move_id`, mv.created_at as `created`, c.name as `name`, c.home_phone, c.cell_phone, c.work_phone, c.email, md.move_date, t.description as `truck_name`, u.name as `author`,
	  				(select ct.name
						from trucks tt
						inner join list_truck_groups lt on tt.id = lt.truck_id
						inner join calendar_truck_groups ct on lt.calendar_truck_group_id = ct.id
						where tt.id = t.id) as `group`,
            (select ud.name
            from users ud
            where ud.id = t.driver) as `driver`,
            (select smses.stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1) as `stage`,
            (select smses.sub_stage from move_status_email_alerts smsea inner join contact_stages smses on smses.id = smsea.contact_stage_id where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1) as `sub_stage`,
            (select mmr.subject from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_subject`,
            (select mmr.body from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_body`,
            (select mmr.message_type from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_type`,
            (select mmr.created_at from messages_move_records mmr where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_time`,
            (select u.name from messages_move_records mmr inner join users u on mmr.user_id = u.id where mmr.move_record_id = mv.id ORDER BY mmr.created_at desc LIMIT 1) as `message_author`,
            (select u.name from move_status_email_alerts smsea inner join users u on smsea.user_id = u.id where smsea.move_record_id = mv.id and smsea.contact_stage_id = ? ORDER BY smsea.created_at desc LIMIT 1) as `booker`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `canceled`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `dispatched`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `confirmed`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `recieved`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `confirmed2`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `confirmed7`,
            (select smsea.contact_stage_id from move_status_email_alerts smsea where mv.id = smsea.move_record_id and smsea.contact_stage_id = ? ORDER BY smsea.`id` desc LIMIT 1) as `recieved2`
						from move_records mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mses on mses.id = msea.contact_stage_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join move_record_trucks mt on mv.id = mt.move_record_id
						left join move_sources ms on mv.move_source_id = ms.id
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join clients c on mc.client_id = c.id
						left join trucks t on mt.truck_id = t.id
						inner join users u on mv.user_id = u.id
						where msea.contact_stage_id = ? AND
						mv.id not in(
							select move_record_id from move_status_email_alerts where contact_stage_id = ?
						)"+
        add_sql +
        " AND mv.account_id = ? " +
        ") AS tbl GROUP BY move_id ORDER BY `" + column_reorder + "` " + type_to_reorder

    sql_posted = filter1.blank? ? sql_posted : sql_posted + filter1
    sql_posted = filter2.blank? ? sql_posted : sql_posted + filter2
    sql_posted = filter3.blank? ? sql_posted : sql_posted + filter3
    sql_posted = filter4.blank? ? sql_posted : sql_posted + filter4
    sql_posted = filter5.blank? ? sql_posted : sql_posted + filter5
    sql_posted = search.blank? ? sql_posted : sql_posted + search

    move_posted = ActiveRecord::Base.connection.exec_query(ActiveRecord::Base.send(:sanitize_sql_array, [sql_posted, book_id, cancel_id, dispatch_id, confirm_id, receive_id, confirm2_id, confirm7_id, receive2_id, book_id, complete_id, account_id]))

    return {move_posted: move_posted}
  end
end
