class AddColumsMoveRecordDefaultSettings < ActiveRecord::Migration
  def change
    add_column :move_record_default_settings, :autosend_lead_welcome, :boolean, default: true

    add_column :move_record_default_settings, :autosend_follow_up_welcome, :boolean, default: false

    add_column :move_record_default_settings, :autosend_quote_welcome, :boolean, default: false
    add_column :move_record_default_settings, :autosend_quote_quote, :boolean, default: false
    add_column :move_record_default_settings, :autosend_quote_callback, :boolean, default: false

    add_column :move_record_default_settings, :autosend_book_welcome, :boolean, default: true
    add_column :move_record_default_settings, :autosend_book_confirm, :boolean, default: false
    add_column :move_record_default_settings, :autosend_book_dispatch, :boolean, default: false

    add_column :move_record_default_settings, :autosend_dispatch_welcome, :boolean, default: false
    add_column :move_record_default_settings, :autosend_dispatch_confirm, :boolean, default: false
    add_column :move_record_default_settings, :autosend_dispatch_dispatch, :boolean, default: false

    add_column :move_record_default_settings, :autosend_confirm_confirm, :boolean, default: false
    add_column :move_record_default_settings, :autosend_confirm_acknowledgement, :boolean, default: false

    add_column :move_record_default_settings, :autosend_receive_confirm, :boolean, default: false
    add_column :move_record_default_settings, :autosend_receive_acknowledgement, :boolean, default: false

    add_column :move_record_default_settings, :autosend_invoice_invoice, :boolean, default: false

    add_column :move_record_default_settings, :autosend_post_thank_you, :boolean, default: false

    add_column :move_record_default_settings, :autosend_aftercare_survey, :boolean, default: false

    add_column :move_record_default_settings, :autosend_unable_unable, :boolean, default: false

    add_column :move_record_default_settings, :autosend_cancel_cancel, :boolean, default: false

  end
end
