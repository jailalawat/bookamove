class Mover < ActiveRecord::Base
  def self.list_move_records(params, current_user)
    book_id = ContactStage.where(account_id: current_user.account_id, stage: "Book").pluck(:id).first

    add_sql = ''
    if (params[:list_move_calendar_start].present? && params[:list_move_calendar_end].present?)
      add_sql += " AND DATE(md.move_date) BETWEEN '" + params[:list_move_calendar_start] + "' AND '" + params[:list_move_calendar_end] + "' "
    end
    if !params[:search]["value"].blank?
      term = params[:search]["value"]
      add_sql += " AND (c.name like '%" + term + "%' or md.move_date like '%" + term + "%' or md.move_time like '%" + term + "%' )"
    end
    column_to_order = params[:order]["0"]["column"]
    type_to_reorder = params[:order]["0"]["dir"]
    column_reorder = params[:columns][column_to_order]["data"]
    sql_posted = "select distinct  mv.id as move_id, c.name as `name` , md.move_date as `date` , md.move_time as `start_time`,
						( select distinct group_concat( u.name  SEPARATOR ',' ) as movers
						  from users u 
						  inner join move_record_trucks mt on  ( u.id = mt.lead or u.id = mt.mover_2 or u.id = mt.mover_3 or u.id = mt.mover_4 or u.id = mt.mover_5 or u.id = mt.mover_6 )
						  where mt.move_record_id = mv.id ) as `movers`
						from move_records mv 
						inner join move_record_dates md on mv.id = md.move_record_id
						inner join move_record_clients mc on mv.id = mc.move_record_id
						inner join clients c on mc.client_id = c.id
						inner join move_record_trucks mvt on mv.id = mvt.move_record_id
						inner join move_status_email_alerts msea on mv.id = msea.move_record_id
						where msea.contact_stage_id = ? " +
        add_sql +
        " AND mv.account_id = ? AND (mvt.lead=? OR mvt.mover_2=? OR mvt.mover_3=? OR mvt.mover_4=? OR mvt.mover_5=? OR mvt.mover_6=?) " +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    pagination_posted = " LIMIT ? OFFSET ?"

    count_list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted,
                                 book_id,
                                 current_user.account_id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id])
    ).count

    list_move = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted,
                                 book_id,
                                 current_user.account_id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 current_user.id,
                                 params[:length].to_i,
                                 params[:start].to_i])
    )

    return {list_move: list_move, count_list_move: count_list_move}
  end
end