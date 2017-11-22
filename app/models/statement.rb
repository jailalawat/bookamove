class Statement < ActiveRecord::Base

  def self.statement(params, account_id, user_id)
    add_sql = ''
    add_sql += " AND DATE(msea.updated_at) BETWEEN '" + DateTime.now.midnight.to_s(:db) + "' AND '" + DateTime.now.end_of_day.to_s(:db) + "' "
    if !params[:search]["value"].blank?
      term = params[:search]["value"]
      add_sql += " AND (c.name like '%" + term + "%' or mv.created_at like '%" + term + "%' or mv.total_cost like '%" + term + "%')"
    end
    column_to_order = params[:order]["0"]["column"]
    type_to_reorder = params[:order]["0"]["dir"]
    column_reorder = params[:columns][column_to_order]["data"]
    select_group_by = "select c.name as `name`, mv.id as `move_id`, mv.created_at as `date`, mv.total_cost as `total_cost`, msea.contact_stage_id, mss.stage, mss.sub_stage"
    sql_posted = " from move_records as mv
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						inner join contact_stages mss on msea.contact_stage_id = mss.id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join clients c on mc.client_id = c.id
						where mv.account_id = ? 
						AND mv.user_id = ? "
    query_params = " ORDER BY `" + column_reorder + "` " + type_to_reorder
    pagination_posted = " LIMIT ? OFFSET ?"
    group = " GROUP BY mv.id "
    count_move_record = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [select_group_by + sql_posted + add_sql + group + query_params, account_id, user_id])
    ).count
    all_records = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [select_group_by + sql_posted + add_sql, account_id, user_id])
    )
    move_record = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [select_group_by + sql_posted + add_sql + group + query_params + pagination_posted, account_id, user_id, params[:length].to_i, params[:start].to_i])
    )
    commissions = chargeCommission(all_records, account_id)
    move_record.each do |move|
      move["total_cost"] = 0.0
      commissions.each do |comm|
        if comm[0].present? && (comm[0]["move_record_id"] == move["move_id"])
          move["total_cost"] += comm[0]["total_commission"].blank? ? 0 : comm[0]["total_commission"].to_f
        end
      end
      x_stage = "stage" if not move["stage"].nil?
      x_stage = "sub_stage" if not move["sub_stage"].nil?
      temp_sql = "select ms." + x_stage.downcase + " as stage
					from  move_status_email_alerts msea inner join
					contact_stages ms on msea.contact_stage_id = ms.id
					where msea.move_record_id = ?"
      record_stages = ActiveRecord::Base.connection.exec_query(
          ActiveRecord::Base.send(:sanitize_sql_array,
                                  [temp_sql, move["move_id"]])
      )
      move["move_stages"] = record_stages.map { |v| v['stage'] }.compact.reject(&:blank?).join(', ')

    end
    if column_reorder == 'total_cost'
      move_record = type_to_reorder == 'asc' ? move_record.sort { |a, b| b["total_cost"] <=> a["total_cost"] } : move_record.sort { |a, b| a["total_cost"] <=> b["total_cost"] }
    end

    return {move_record: move_record, count_move_record: count_move_record}
  end

  private

  def self.chargeCommission(move_record, account_id)
    all_commissions = Array.new
    move_record.each do |move|
      x_stage = move["stage"] || move["sub_stage"]
      table = ActiveRecord::Base.connection.exec_query("show tables like '"+ x_stage.downcase+"_commission_move_records'").count
      if table > 0
        sql_dynamic = "select cm.total_commission , cm.move_record_id
						  from " + x_stage.downcase + "_commission_move_records as cm
						  where cm.account_id = ? AND cm.move_record_id  = ?"
        all_commissions << ActiveRecord::Base.connection.exec_query(
            ActiveRecord::Base.send(:sanitize_sql_array,
                                    [sql_dynamic, account_id, move["move_id"].to_i])
        )
      end
    end
    return all_commissions
  end
end