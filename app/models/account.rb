class Account < ActiveRecord::Base
  has_many :user
  after_commit :clear_cache

  mount_uploader :logo, PictureUploader
  validate :picture_size

  def self.list(report_calendar_start, report_calendar_end, search, order, columns, length, start)
    add_sql = ''
    if (report_calendar_start.present? && report_calendar_end.present?)
      add_sql += " WHERE DATE(a.created_at) BETWEEN '" + report_calendar_start + "' AND '" + report_calendar_end + "' "
    end
    if !search["value"].blank?
      term = search["value"]
      add_sql += " AND (a.name like '%" + term + "%' or a.email like '%" + term + "%' or a.site like '%" + term + "%' or a.office_phone like '%" + term + "%'  or a.subdomain like '%" + term + "%' or a.created_at like '%" + term + "%')"
    end
    column_to_order = order["0"]["column"]
    type_to_reorder = order["0"]["dir"]
    column_reorder = columns[column_to_order]["data"]
    sql_posted = "SELECT a.id, a.name, a.email, a.site, a.office_phone, a.subdomain, a.created_at
	  					FROM accounts as a "+
        add_sql +
        " ORDER BY `" + column_reorder + "` " + type_to_reorder
    pagination_posted = " LIMIT ? OFFSET ?"
    count_list = ActiveRecord::Base.connection.exec_query(sql_posted).count
    list_posted = ActiveRecord::Base.connection.exec_query(
        ActiveRecord::Base.send(:sanitize_sql_array,
                                [sql_posted + pagination_posted, length.to_i, start.to_i])
    )
    return {list_posted: list_posted, count_list: count_list}
  end

  private
  # Validates the size of an uploaded picture.
  def picture_size
    if logo.size > 5.megabytes
      errors.add(:logo, "should be less than 5MB")
    end
  end

  def clear_cache
    Rails.cache.delete("account_logo/#{self.subdomain}")
  end

end
