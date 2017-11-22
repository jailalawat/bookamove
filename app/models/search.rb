class Search < ActiveRecord::Base

  def self.search(params, account_id)
    current_page = params[:page].blank? || params[:page] == "0" ? 1 : params[:page]
    per_page = 5
    page = current_page.to_i * per_page.to_i
    current_page = page.to_i / per_page.to_i
    add_sql = ''
    if !params[:search].blank?
      term = params[:search]
      add_sql += " AND (c.name like '%" + term + "%' or c.home_phone like '%" + term + "%' or c.cell_phone like '%" + term + "%' or c.work_phone like '%" + term + "%' or c.email like '%" + term + "%' or mv.old_system_id like '%" + term + "%')"
    end
    sql_posted = "select c.name as `name`, mv.id as `move_id`, c.home_phone, c.cell_phone as `cell`, c.work_phone, c.email,
						(select smses.stage
						  from move_status_email_alerts smsea 
						  inner join contact_stages smses on smses.id = smsea.contact_stage_id
						  where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1 ) as `stage`,
            (select smses.sub_stage
						  from move_status_email_alerts smsea
						  inner join contact_stages smses on smses.id = smsea.contact_stage_id
						  where mv.id = smsea.move_record_id ORDER BY smsea.`created_at` desc LIMIT 1 ) as `sub_stage`,
						(select city
						  from move_record_location_origins ml
						  inner join locations l on ml.location_id = l.id 
						  where mv.id = ml.move_record_id ORDER BY ml.`created_at` desc LIMIT 1  ) as origin,
						(select city
						  from move_record_location_destinations ml
						  inner join locations l on ml.location_id = l.id 
						  where mv.id = ml.move_record_id ORDER BY ml.`created_at` desc LIMIT 1 ) as destination
						from move_records mv 
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join clients c on mc.client_id = c.id"+
        " where mv.account_id = ? " +
        add_sql
    pagination_posted = " LIMIT ? OFFSET ?"
    count_move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted, account_id])
    ).count
    total_pages = count_move_posted.to_f / per_page.to_f
    if params[:page].to_i > total_pages.to_i + 1
      current_page = 0
      page = 5
    end
    move_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, account_id, per_page, page.to_i - per_page])
    )

    trucks = MoveRecordTruck.where(move_record_id: move_posted.map { |e| e['move_id'] })


    return {move_posted: move_posted, trucks: trucks, current_page: current_page.to_i, total_pages: total_pages.ceil}
  end
end