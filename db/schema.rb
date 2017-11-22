# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171020224032) do

  create_table "access_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_access_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_access_alerts_on_description", using: :btree
  end

  create_table "accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "logo"
    t.string   "email"
    t.string   "site"
    t.string   "toll_free_phone"
    t.string   "building"
    t.string   "office_phone"
    t.string   "city"
    t.string   "fax"
    t.string   "locale"
    t.string   "website"
    t.string   "province"
    t.string   "postal_code"
    t.string   "subdomain"
    t.string   "bio"
    t.string   "address"
    t.boolean  "active",              default: true
    t.boolean  "is_admin",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "working_hours"
    t.string   "privacy_web_page"
    t.string   "contact_us_web_page"
    t.index ["subdomain", "email"], name: "index_accounts_on_subdomain_and_email", unique: true, using: :btree
  end

  create_table "action_roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "role_id"
    t.integer  "action_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "role_id", "action_id"], name: "index_action_roles_on_account_id_and_role_id_and_action_id", unique: true, using: :btree
    t.index ["action_id"], name: "action_roles_action_id_fk", using: :btree
    t.index ["role_id"], name: "action_roles_role_id_fk", using: :btree
  end

  create_table "action_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "action_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "user_id", "action_id"], name: "index_action_users_on_account_id_and_user_id_and_action_id", unique: true, using: :btree
    t.index ["action_id"], name: "action_users_action_id_fk", using: :btree
    t.index ["user_id"], name: "action_users_user_id_fk", using: :btree
  end

  create_table "actions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.string   "key"
    t.boolean  "is_admin_section", default: false
    t.string   "group"
    t.integer  "role_level",       default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["key"], name: "index_actions_on_key", using: :btree
  end

  create_table "aftercare_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_aftercare_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_aftercare_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_aftercare_commission_move_records_on_user_id", using: :btree
  end

  create_table "aftercare_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_aftercare_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_aftercare_commissions_on_user_id", using: :btree
  end

  create_table "book_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_book_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_book_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_book_commission_move_records_on_user_id", using: :btree
  end

  create_table "book_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_book_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_book_commissions_on_user_id", using: :btree
  end

  create_table "calendar_staff_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "account_id"
    t.boolean  "active",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "calendar_staff_groups_account_id_fk", using: :btree
  end

  create_table "calendar_truck_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "account_id"
    t.boolean  "active",       default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone_number"
    t.string   "address"
    t.integer  "province_id"
    t.integer  "city_id"
    t.integer  "locale_id"
    t.index ["account_id"], name: "calendar_truck_groups_account_id_fk", using: :btree
  end

  create_table "cargo_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_cargo_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_cargo_alerts_on_description", using: :btree
  end

  create_table "cargo_templates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.integer  "furnishing_id"
    t.float    "unit_weight",   limit: 24, default: 0.0
    t.float    "unit_volume",   limit: 24, default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["furnishing_id"], name: "index_cargo_templates_on_furnishing_id", using: :btree
  end

  create_table "cargo_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_cargo_types_on_account_id", using: :btree
    t.index ["description"], name: "index_cargo_types_on_description", using: :btree
  end

  create_table "cities", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "province_id"
    t.index ["account_id"], name: "index_cities_on_account_id", using: :btree
    t.index ["description"], name: "index_cities_on_description", using: :btree
    t.index ["province_id"], name: "index_cities_on_province_id", using: :btree
  end

  create_table "city_locales", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "locale_name"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["city_id"], name: "index_city_locales_on_city_id", using: :btree
  end

  create_table "clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "title"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "work_phone"
    t.string   "email"
    t.boolean  "active",     default: true
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_clients_on_account_id", using: :btree
    t.index ["name"], name: "index_clients_on_name", using: :btree
    t.index ["user_id"], name: "index_clients_on_user_id", using: :btree
  end

  create_table "company_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "total_move",                 limit: 24, default: 0.0
    t.float    "total_storage",              limit: 24, default: 0.0
    t.float    "total_packing",              limit: 24, default: 0.0
    t.float    "total_insurance",            limit: 24, default: 0.0
    t.float    "total_other",                limit: 24, default: 0.0
    t.float    "total_blank",                limit: 24, default: 0.0
    t.float    "total_company",              limit: 24, default: 0.0
    t.float    "total_move_percentage",      limit: 24, default: 0.0
    t.float    "total_storage_percentage",   limit: 24, default: 0.0
    t.float    "total_packing_percentage",   limit: 24, default: 0.0
    t.float    "total_insurance_percentage", limit: 24, default: 0.0
    t.float    "total_other_percentage",     limit: 24, default: 0.0
    t.float    "total_blank_percentage",     limit: 24, default: 0.0
    t.float    "total_company_percentage",   limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_company_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_company_commission_move_records_on_move_record_id", using: :btree
  end

  create_table "config_parameters", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.string   "description"
    t.string   "key_description"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "config_parameters_account_id_fk", using: :btree
    t.index ["key_description"], name: "index_config_parameters_on_key_description", unique: true, using: :btree
  end

  create_table "confirm_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_confirm_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_confirm_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_confirm_commission_move_records_on_user_id", using: :btree
  end

  create_table "confirm_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_confirm_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_confirm_commissions_on_user_id", using: :btree
  end

  create_table "contact_stage_emails", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "contact_stage_id"
    t.integer  "email_alert_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "contact_stages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.string   "stage"
    t.integer  "stage_num"
    t.string   "sub_stage"
    t.integer  "sub_stage_num"
    t.integer  "position"
    t.boolean  "active",        default: true
    t.boolean  "default",       default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["account_id"], name: "index_contact_stages_on_account_id", using: :btree
    t.index ["position"], name: "index_contact_stages_on_position", using: :btree
    t.index ["stage_num"], name: "index_contact_stages_on_stage_num", using: :btree
    t.index ["sub_stage_num"], name: "index_contact_stages_on_sub_stage_num", using: :btree
  end

  create_table "dispatch_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_dispatch_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_dispatch_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_dispatch_commission_move_records_on_user_id", using: :btree
  end

  create_table "dispatch_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_dispatch_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_dispatch_commissions_on_user_id", using: :btree
  end

  create_table "driver_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_driver_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_driver_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_driver_commission_move_records_on_user_id", using: :btree
  end

  create_table "driver_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_driver_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_driver_commissions_on_user_id", using: :btree
  end

  create_table "email_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.string   "description"
    t.text     "template",     limit: 65535
    t.boolean  "active",                     default: true
    t.boolean  "default",                    default: false
    t.boolean  "auto_send",                  default: false
    t.integer  "stage_num"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "instructions"
    t.index ["account_id"], name: "index_email_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_email_alerts_on_description", using: :btree
  end

  create_table "email_messages_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "messages_move_record_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_email_messages_move_records_on_account_id", using: :btree
    t.index ["messages_move_record_id"], name: "index_email_messages_move_records_on_messages_move_record_id", using: :btree
    t.index ["user_id"], name: "index_email_messages_move_records_on_user_id", using: :btree
  end

  create_table "equipment_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_equipment_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_equipment_alerts_on_description", using: :btree
  end

  create_table "furnishings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.integer  "room_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["room_id"], name: "index_furnishings_on_room_id", using: :btree
  end

  create_table "general_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.string   "description"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "type"
    t.index ["account_id"], name: "index_general_settings_on_account_id", using: :btree
  end

  create_table "image_accounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "image_accounts_account_id_fk", using: :btree
  end

  create_table "image_profiles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "user_id"
    t.integer  "account_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "image_profiles_account_id_fk", using: :btree
    t.index ["user_id"], name: "image_profiles_user_id_fk", using: :btree
  end

  create_table "image_trucks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "truck_id"
    t.integer  "account_id"
    t.string   "file"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "image_trucks_account_id_fk", using: :btree
    t.index ["truck_id"], name: "image_trucks_truck_id_fk", using: :btree
  end

  create_table "invoice_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_invoice_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_invoice_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_invoice_commission_move_records_on_user_id", using: :btree
  end

  create_table "invoice_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_invoice_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_invoice_commissions_on_user_id", using: :btree
  end

  create_table "lead_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_lead_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_lead_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_lead_commission_move_records_on_user_id", using: :btree
  end

  create_table "lead_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_lead_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_lead_commissions_on_user_id", using: :btree
  end

  create_table "list_truck_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "calendar_truck_group_id"
    t.integer  "truck_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_list_truck_groups_on_account_id", using: :btree
    t.index ["calendar_truck_group_id"], name: "index_list_truck_groups_on_calendar_truck_group_id", using: :btree
    t.index ["truck_id"], name: "index_list_truck_groups_on_truck_id", using: :btree
  end

  create_table "locations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "no"
    t.string   "street"
    t.string   "apartment"
    t.string   "entry_number"
    t.string   "building"
    t.string   "city"
    t.string   "locale"
    t.string   "province"
    t.string   "postal_code"
    t.string   "access_details"
    t.string   "access_alert_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calendar_truck_group_id"
    t.index ["access_alert_id"], name: "locations_access_alert_id_fk", using: :btree
    t.index ["account_id"], name: "locations_account_id_fk", using: :btree
    t.index ["calendar_truck_group_id"], name: "locations_calendar_truck_group_id_fk", using: :btree
  end

  create_table "message_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "message_id"
    t.string   "file_path"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_message_attachments_on_account_id", using: :btree
    t.index ["message_id"], name: "index_message_attachments_on_message_id", using: :btree
  end

  create_table "messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",       limit: 65535
    t.integer  "urgent",                   default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_messages_on_account_id", using: :btree
    t.index ["parent_id"], name: "index_messages_on_parent_id", using: :btree
    t.index ["user_id"], name: "index_messages_on_user_id", using: :btree
  end

  create_table "messages_move_record_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "messages_move_record_id"
    t.string   "file_path"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "messages_move_record_attachments_account_id_fk", using: :btree
    t.index ["messages_move_record_id"], name: "messages_move_record_attachments_messages_move_record_id_fk", using: :btree
  end

  create_table "messages_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "move_record_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",           limit: 65535
    t.integer  "urgent",                       default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message_type"
    t.index ["account_id"], name: "index_messages_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_messages_move_records_on_move_record_id", using: :btree
    t.index ["parent_id"], name: "index_messages_move_records_on_parent_id", using: :btree
    t.index ["user_id"], name: "index_messages_move_records_on_user_id", using: :btree
  end

  create_table "messages_staff_available_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "staff_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",          limit: 65535
    t.integer  "urgent",                      default: 0
    t.datetime "date_calendar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_messages_staff_available_calendars_on_account_id", using: :btree
    t.index ["parent_id"], name: "index_messages_staff_available_calendars_on_parent_id", using: :btree
    t.index ["staff_id"], name: "index_messages_staff_available_calendars_on_staff_id", using: :btree
    t.index ["user_id"], name: "index_messages_staff_available_calendars_on_user_id", using: :btree
  end

  create_table "messages_task_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "messages_task_id"
    t.string   "file_path"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_messages_task_attachments_on_account_id", using: :btree
    t.index ["messages_task_id"], name: "index_messages_task_attachments_on_messages_task_id", using: :btree
  end

  create_table "messages_task_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "calendar_staff_group_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",                    limit: 65535
    t.integer  "urgent",                                default: 0
    t.datetime "date_calendar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_messages_task_calendars_on_account_id", using: :btree
    t.index ["calendar_staff_group_id"], name: "index_messages_task_calendars_on_calendar_staff_group_id", using: :btree
    t.index ["parent_id"], name: "index_messages_task_calendars_on_parent_id", using: :btree
    t.index ["user_id"], name: "index_messages_task_calendars_on_user_id", using: :btree
  end

  create_table "messages_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "subtask_staff_group_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",                   limit: 65535
    t.integer  "urgent",                               default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "task_sender_id"
    t.index ["account_id"], name: "index_messages_tasks_on_account_id", using: :btree
    t.index ["parent_id"], name: "index_messages_tasks_on_parent_id", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_messages_tasks_on_subtask_staff_group_id", using: :btree
    t.index ["task_sender_id"], name: "messages_tasks_task_sender_id_fk", using: :btree
    t.index ["user_id"], name: "index_messages_tasks_on_user_id", using: :btree
  end

  create_table "messages_truck_available_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "truck_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",          limit: 65535
    t.integer  "urgent",                      default: 0
    t.datetime "date_calendar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_messages_truck_available_calendars_on_account_id", using: :btree
    t.index ["parent_id"], name: "index_messages_truck_available_calendars_on_parent_id", using: :btree
    t.index ["truck_id"], name: "index_messages_truck_available_calendars_on_truck_id", using: :btree
    t.index ["user_id"], name: "index_messages_truck_available_calendars_on_user_id", using: :btree
  end

  create_table "messages_truck_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "calendar_truck_group_id"
    t.integer  "parent_id"
    t.string   "subject"
    t.text     "body",                    limit: 65535
    t.integer  "urgent",                                default: 0
    t.datetime "date_calendar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_messages_truck_calendars_on_account_id", using: :btree
    t.index ["calendar_truck_group_id"], name: "index_messages_truck_calendars_on_calendar_truck_group_id", using: :btree
    t.index ["parent_id"], name: "index_messages_truck_calendars_on_parent_id", using: :btree
    t.index ["user_id"], name: "index_messages_truck_calendars_on_user_id", using: :btree
  end

  create_table "move_keywords", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_keywords_on_account_id", using: :btree
    t.index ["description"], name: "index_move_keywords_on_description", using: :btree
  end

  create_table "move_record_cargos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.float    "quantity",       limit: 24, default: 0.0
    t.float    "unit_volume",    limit: 24, default: 0.0
    t.float    "unit_weight",    limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_cargos_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "index_move_record_cargos_on_move_record_id", using: :btree
  end

  create_table "move_record_clients", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "client_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_clients_account_id_fk", using: :btree
    t.index ["client_id"], name: "move_record_clients_client_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_clients_move_record_id_fk", using: :btree
  end

  create_table "move_record_cost_hourlies", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "start"
    t.string   "stop"
    t.string   "hours"
    t.string   "breaks"
    t.string   "travel"
    t.string   "estimate_time"
    t.string   "actual"
    t.string   "hourly_rate"
    t.string   "move_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_cost_hourlies_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_cost_hourlies_move_record_id_fk", using: :btree
  end

  create_table "move_record_dates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.datetime "move_date"
    t.datetime "move_time"
    t.string   "time_alert_id"
    t.string   "time_range"
    t.string   "time_detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "estimation_time"
    t.index ["account_id"], name: "move_record_dates_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_dates_move_record_id_fk", using: :btree
    t.index ["time_alert_id"], name: "move_record_dates_time_alert_id_fk", using: :btree
  end

  create_table "move_record_default_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "number_of_clients",                default: 1
    t.integer  "number_of_trucks",                 default: 1
    t.integer  "number_of_origin",                 default: 1
    t.integer  "number_of_destination",            default: 1
    t.integer  "number_of_date",                   default: 1
    t.boolean  "show_move_type",                   default: true
    t.boolean  "show_move_type_details",           default: true
    t.boolean  "show_move_type_alert",             default: true
    t.integer  "move_type_id"
    t.integer  "move_type_alert_id"
    t.boolean  "show_move_source",                 default: true
    t.boolean  "show_move_keyword",                default: true
    t.boolean  "show_move_webpage",                default: true
    t.boolean  "show_move_referral",               default: true
    t.boolean  "show_move_source_detail",          default: true
    t.boolean  "show_move_source_alert",           default: true
    t.integer  "move_source_id"
    t.integer  "move_keyword_id"
    t.integer  "move_webpage_id"
    t.integer  "move_referral_id"
    t.integer  "move_source_alert_id"
    t.boolean  "show_cargo_type",                  default: true
    t.boolean  "show_cargo_descriptor",            default: true
    t.boolean  "show_cargo_room",                  default: true
    t.boolean  "show_cargo_weight",                default: true
    t.boolean  "show_cargo_cubic",                 default: true
    t.boolean  "show_cargo_details",               default: true
    t.boolean  "show_cargo_alert",                 default: true
    t.boolean  "show_description",                 default: true
    t.integer  "cargo_type_id"
    t.string   "cargo_detail"
    t.integer  "cargo_alert_id"
    t.string   "cargo_description"
    t.boolean  "show_origin_no",                   default: true
    t.boolean  "show_origin_street",               default: true
    t.boolean  "show_origin_apartment",            default: true
    t.boolean  "show_origin_entry_number",         default: true
    t.boolean  "show_origin_building",             default: true
    t.boolean  "show_origin_city",                 default: true
    t.boolean  "show_origin_locale",               default: true
    t.boolean  "show_origin_province",             default: true
    t.boolean  "show_origin_postal_code",          default: true
    t.boolean  "show_origin_access_details",       default: true
    t.boolean  "show_origin_access_alert",         default: true
    t.integer  "origin_access_alert_id"
    t.boolean  "show_destination_no",              default: true
    t.boolean  "show_destination_street",          default: true
    t.boolean  "show_destination_apartment",       default: true
    t.boolean  "show_destination_entry_number",    default: true
    t.boolean  "show_destination_building",        default: true
    t.boolean  "show_destination_city",            default: true
    t.boolean  "show_destination_locale",          default: true
    t.boolean  "show_destination_province",        default: true
    t.boolean  "show_destination_postal_code",     default: true
    t.boolean  "show_destination_access_details",  default: true
    t.boolean  "show_destination_access_alert",    default: true
    t.integer  "destination_access_alert_id"
    t.boolean  "show_move_date",                   default: true
    t.boolean  "show_move_time",                   default: true
    t.boolean  "show_move_range",                  default: true
    t.boolean  "show_move_time_detail",            default: true
    t.integer  "time_alert_id"
    t.boolean  "show_time_alert",                  default: true
    t.boolean  "show_truck",                       default: true
    t.boolean  "show_truck_name",                  default: true
    t.boolean  "show_truck_equipment_details",     default: true
    t.boolean  "show_truck_name_equipment_alert",  default: true
    t.integer  "truck_id"
    t.integer  "equipment_alert_id"
    t.integer  "number_man_id"
    t.boolean  "show_men",                         default: true
    t.boolean  "show_lead",                        default: true
    t.boolean  "show_mover_2",                     default: true
    t.boolean  "show_mover_3",                     default: true
    t.boolean  "show_mover_4",                     default: true
    t.boolean  "show_mover_5",                     default: true
    t.boolean  "show_mover_6",                     default: true
    t.boolean  "show_who_note",                    default: true
    t.boolean  "show_what_note",                   default: true
    t.boolean  "show_where_note",                  default: true
    t.boolean  "show_when_note",                   default: true
    t.boolean  "show_how_note",                    default: true
    t.boolean  "show_cost_note",                   default: true
    t.boolean  "show_contract_note",               default: true
    t.boolean  "show_contract_stage",              default: true
    t.boolean  "show_move_cost",                   default: true
    t.boolean  "show_packing",                     default: true
    t.boolean  "show_other_cost",                  default: true
    t.boolean  "show_surcharge",                   default: true
    t.boolean  "show_flat_rate",                   default: true
    t.boolean  "show_discount",                    default: true
    t.boolean  "show_insurance",                   default: true
    t.boolean  "show_fuel_cost",                   default: true
    t.boolean  "show_payment",                     default: true
    t.boolean  "checked_cost_hourly",              default: true
    t.boolean  "checked_packing",                  default: true
    t.boolean  "checked_other_cost",               default: true
    t.boolean  "checked_surchage",                 default: true
    t.boolean  "checked_flat_rate",                default: true
    t.boolean  "checked_discount",                 default: true
    t.boolean  "checked_insurance",                default: true
    t.boolean  "checked_fuel_cost",                default: true
    t.boolean  "checked_payment",                  default: true
    t.integer  "packing_alert_id"
    t.integer  "payment_alert_id"
    t.boolean  "show_follow_up",                   default: true
    t.boolean  "show_quote",                       default: true
    t.boolean  "show_book",                        default: true
    t.boolean  "show_dispatch",                    default: true
    t.boolean  "show_confirm",                     default: true
    t.boolean  "show_receive",                     default: true
    t.boolean  "show_active",                      default: true
    t.boolean  "show_complete",                    default: true
    t.boolean  "show_unable",                      default: true
    t.boolean  "show_cancel",                      default: true
    t.boolean  "show_submit",                      default: true
    t.boolean  "show_invoice",                     default: true
    t.boolean  "show_post",                        default: true
    t.boolean  "show_aftercare",                   default: true
    t.boolean  "show_lead_welcome",                default: true
    t.boolean  "show_follow_up_welcome",           default: true
    t.boolean  "show_quote_welcome",               default: true
    t.boolean  "show_quote_quote",                 default: true
    t.boolean  "show_quote_callback",              default: true
    t.boolean  "show_book_welcome",                default: true
    t.boolean  "show_book_confirm",                default: true
    t.boolean  "show_book_dispatch",               default: true
    t.boolean  "show_dispatch_welcome",            default: true
    t.boolean  "show_dispatch_confirm",            default: true
    t.boolean  "show_dispatch_dispatch",           default: true
    t.boolean  "show_confirm_confirm",             default: true
    t.boolean  "show_confirm_acknowledgement",     default: true
    t.boolean  "show_receive_confirm",             default: true
    t.boolean  "show_receive_acknowledgement",     default: true
    t.boolean  "show_unable_unable",               default: true
    t.boolean  "show_cancel_cancel",               default: true
    t.boolean  "show_invoice_invoice",             default: true
    t.boolean  "show_post_thankyou",               default: true
    t.boolean  "show_aftercare_survey",            default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "show_estimation_time",             default: true
    t.boolean  "show_origin_calendar_truck_group", default: true
    t.integer  "origin_calendar_truck_group_id"
    t.boolean  "autosend_lead_welcome",            default: true
    t.boolean  "autosend_follow_up_welcome",       default: false
    t.boolean  "autosend_quote_welcome",           default: false
    t.boolean  "autosend_quote_quote",             default: false
    t.boolean  "autosend_quote_callback",          default: false
    t.boolean  "autosend_book_welcome",            default: true
    t.boolean  "autosend_book_confirm",            default: false
    t.boolean  "autosend_book_dispatch",           default: false
    t.boolean  "autosend_dispatch_welcome",        default: false
    t.boolean  "autosend_dispatch_confirm",        default: false
    t.boolean  "autosend_dispatch_dispatch",       default: false
    t.boolean  "autosend_confirm_confirm",         default: false
    t.boolean  "autosend_confirm_acknowledgement", default: false
    t.boolean  "autosend_receive_confirm",         default: false
    t.boolean  "autosend_receive_acknowledgement", default: false
    t.boolean  "autosend_invoice_invoice",         default: false
    t.boolean  "autosend_post_thank_you",          default: false
    t.boolean  "autosend_aftercare_survey",        default: false
    t.boolean  "autosend_unable_unable",           default: false
    t.boolean  "autosend_cancel_cancel",           default: false
    t.boolean  "show_contract_stage_detail",       default: true
    t.boolean  "show_move_stage_alert",            default: true
    t.integer  "move_stage_alerts_id"
    t.integer  "move_subsource_id"
    t.index ["account_id"], name: "move_record_default_settings_account_id_fk", using: :btree
    t.index ["cargo_alert_id"], name: "move_record_default_settings_cargo_alert_id_fk", using: :btree
    t.index ["cargo_type_id"], name: "move_record_default_settings_cargo_type_id_fk", using: :btree
    t.index ["destination_access_alert_id"], name: "move_record_default_settings_destination_access_alert_id_fk", using: :btree
    t.index ["equipment_alert_id"], name: "move_record_default_settings_equipment_alert_id_fk", using: :btree
    t.index ["move_keyword_id"], name: "move_record_default_settings_move_keyword_id_fk", using: :btree
    t.index ["move_referral_id"], name: "move_record_default_settings_move_referral_id_fk", using: :btree
    t.index ["move_source_alert_id"], name: "move_record_default_settings_move_source_alert_id_fk", using: :btree
    t.index ["move_source_id"], name: "move_record_default_settings_move_source_id_fk", using: :btree
    t.index ["move_stage_alerts_id"], name: "index_move_record_default_settings_on_move_stage_alerts_id", using: :btree
    t.index ["move_type_alert_id"], name: "move_record_default_settings_move_type_alert_id_fk", using: :btree
    t.index ["move_type_id"], name: "move_record_default_settings_move_type_id_fk", using: :btree
    t.index ["move_webpage_id"], name: "move_record_default_settings_move_webpage_id_fk", using: :btree
    t.index ["origin_access_alert_id"], name: "move_record_default_settings_origin_access_alert_id_fk", using: :btree
    t.index ["packing_alert_id"], name: "move_record_default_settings_packing_alert_id_fk", using: :btree
    t.index ["payment_alert_id"], name: "move_record_default_settings_payment_alert_id_fk", using: :btree
    t.index ["time_alert_id"], name: "move_record_default_settings_time_alert_id_fk", using: :btree
    t.index ["truck_id"], name: "move_record_default_settings_truck_id_fk", using: :btree
  end

  create_table "move_record_discounts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "percentage"
    t.string   "hourly"
    t.string   "notes"
    t.string   "discount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_discounts_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_discounts_move_record_id_fk", using: :btree
  end

  create_table "move_record_flat_rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "notes"
    t.string   "move_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_flat_rates_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_flat_rates_move_record_id_fk", using: :btree
  end

  create_table "move_record_fuel_costs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "percentage_mc"
    t.string   "fixed"
    t.string   "notes"
    t.string   "fuel_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_fuel_costs_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_fuel_costs_move_record_id_fk", using: :btree
  end

  create_table "move_record_insurances", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "declared_value"
    t.string   "dolar_k"
    t.string   "description"
    t.string   "insurance_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_insurances_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_insurances_move_record_id_fk", using: :btree
  end

  create_table "move_record_location_destinations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_location_destinations_account_id_fk", using: :btree
    t.index ["location_id"], name: "move_record_location_destinations_location_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_location_destinations_move_record_id_fk", using: :btree
  end

  create_table "move_record_location_origins", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_location_origins_account_id_fk", using: :btree
    t.index ["location_id"], name: "move_record_location_origins_location_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_location_origins_move_record_id_fk", using: :btree
  end

  create_table "move_record_notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.text     "body",           limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_record_notes_on_account_id", using: :btree
    t.index ["move_record_id"], name: "move_record_notes_move_record_id_fk", using: :btree
  end

  create_table "move_record_other_costs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.boolean  "gst"
    t.decimal  "percentage_gst", precision: 10, scale: 2, default: "0.0"
    t.boolean  "pst"
    t.decimal  "percentage_pst", precision: 10, scale: 2, default: "0.0"
    t.string   "description"
    t.string   "other_cost"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_other_costs_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_other_costs_move_record_id_fk", using: :btree
  end

  create_table "move_record_packings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "boxes"
    t.string   "paper"
    t.string   "tape"
    t.string   "wrap"
    t.string   "bags"
    t.string   "box_rent"
    t.string   "packing_alert_id"
    t.string   "other"
    t.string   "total_packing"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_packings_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_packings_move_record_id_fk", using: :btree
    t.index ["packing_alert_id"], name: "move_record_packings_packing_alert_id_fk", using: :btree
  end

  create_table "move_record_payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.string   "type_payment"
    t.string   "status"
    t.string   "number_card"
    t.string   "exp"
    t.string   "cvc"
    t.string   "number_transaction"
    t.string   "pre_auth"
    t.string   "amount"
    t.datetime "date"
    t.string   "payment_detail"
    t.string   "payment_alert_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_payments_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_payments_move_record_id_fk", using: :btree
    t.index ["payment_alert_id"], name: "move_record_payments_payment_alert_id_fk", using: :btree
  end

  create_table "move_record_submits", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.boolean  "signed_acceptance"
    t.boolean  "signed_completion"
    t.boolean  "release_to"
    t.boolean  "purshased_rvp"
    t.boolean  "accepted_weight_charges"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "break_time"
    t.float    "actual_lb",                  limit: 24, default: 0.0
    t.float    "min_lb",                     limit: 24, default: 0.0
    t.float    "min_lb_dolar",               limit: 24, default: 0.0
    t.float    "min_lb_dolar_client",        limit: 24, default: 0.0
    t.float    "dolar_lb",                   limit: 24, default: 0.0
    t.float    "dolar_lb_client",            limit: 24, default: 0.0
    t.float    "rate_actual",                limit: 24, default: 0.0
    t.float    "total_time_actual",          limit: 24, default: 0.0
    t.float    "flat_rate_actual",           limit: 24, default: 0.0
    t.float    "move_cost_actual",           limit: 24, default: 0.0
    t.float    "discount_actual",            limit: 24, default: 0.0
    t.float    "discount_move_cost_actual",  limit: 24, default: 0.0
    t.float    "packing_supplies_actual",    limit: 24, default: 0.0
    t.float    "other_cost_actual",          limit: 24, default: 0.0
    t.float    "surchage_actual",            limit: 24, default: 0.0
    t.float    "rvp_calculated",             limit: 24, default: 0.0
    t.float    "rvp_actual",                 limit: 24, default: 0.0
    t.float    "subtotal_actual",            limit: 24, default: 0.0
    t.float    "gst_actual",                 limit: 24, default: 0.0
    t.float    "deposit_actual",             limit: 24, default: 0.0
    t.float    "total_actual",               limit: 24, default: 0.0
    t.string   "payment_type_one"
    t.string   "total_client_one"
    t.string   "card_number_one"
    t.string   "expiry_one"
    t.string   "cvc_one"
    t.string   "moneris_id_one"
    t.string   "pre_auth_one"
    t.string   "payment_date_one"
    t.string   "payment_type_two"
    t.string   "total_client_two"
    t.string   "card_number_two"
    t.string   "expiry_two"
    t.string   "cvc_two"
    t.string   "moneris_id_two"
    t.string   "pre_auth_two"
    t.string   "payment_date_two"
    t.float    "client_received",            limit: 24, default: 0.0
    t.float    "company_received",           limit: 24, default: 0.0
    t.boolean  "receive_all_cash"
    t.boolean  "signed_credit_card"
    t.string   "origin_access_comment"
    t.string   "destination_access_comment"
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_submits_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "index_move_record_submits_on_move_record_id", using: :btree
  end

  create_table "move_record_surcharges", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.boolean  "gst"
    t.decimal  "percentage_gst", precision: 10, scale: 2, default: "0.0"
    t.boolean  "pst"
    t.decimal  "percentage_pst", precision: 10, scale: 2, default: "0.0"
    t.string   "description"
    t.string   "surcharge"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "move_record_surcharges_account_id_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_surcharges_move_record_id_fk", using: :btree
  end

  create_table "move_record_trucks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "move_record_id"
    t.integer  "truck_id"
    t.integer  "account_id"
    t.string   "truck_name"
    t.string   "equipment_details"
    t.string   "equipment_alert_id"
    t.integer  "number_man_id"
    t.integer  "lead"
    t.integer  "mover_2"
    t.integer  "mover_3"
    t.integer  "mover_4"
    t.integer  "mover_5"
    t.integer  "mover_6"
    t.string   "lead_hour"
    t.string   "mover_2_hour"
    t.string   "mover_3_hour"
    t.string   "mover_4_hour"
    t.string   "mover_5_hour"
    t.string   "mover_6_hour"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_record_trucks_on_account_id", using: :btree
    t.index ["equipment_alert_id"], name: "move_record_trucks_equipment_alert_id_fk", using: :btree
    t.index ["lead"], name: "move_record_trucks_lead_fk", using: :btree
    t.index ["move_record_id"], name: "move_record_trucks_move_record_id_fk", using: :btree
    t.index ["mover_2"], name: "move_record_trucks_mover_2_fk", using: :btree
    t.index ["mover_3"], name: "move_record_trucks_mover_3_fk", using: :btree
    t.index ["mover_4"], name: "move_record_trucks_mover_4_fk", using: :btree
    t.index ["mover_5"], name: "move_record_trucks_mover_5_fk", using: :btree
    t.index ["mover_6"], name: "move_record_trucks_mover_6_fk", using: :btree
    t.index ["truck_id"], name: "index_move_record_trucks_on_truck_id", using: :btree
  end

  create_table "move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "old_system_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "move_type_id"
    t.string   "move_type_detail"
    t.string   "move_type_alert_id"
    t.string   "move_source_id"
    t.string   "move_subsource_id"
    t.string   "move_keyword_id"
    t.string   "move_webpage_id"
    t.string   "move_referral_id"
    t.string   "referral2"
    t.string   "move_source_alert_id"
    t.string   "cargo_type_id"
    t.string   "cargo_descriptor"
    t.string   "cargo_room"
    t.string   "cargo_weight"
    t.string   "cargo_cubic"
    t.string   "cargo_detail"
    t.string   "cargo_alert_id"
    t.string   "cargo_description"
    t.text     "who_note",                   limit: 65535
    t.text     "what_note",                  limit: 65535
    t.text     "where_note",                 limit: 65535
    t.text     "when_note",                  limit: 65535
    t.text     "how_note",                   limit: 65535
    t.text     "cost_note",                  limit: 65535
    t.text     "contract_note",              limit: 65535
    t.text     "contract_stage_note",        limit: 65535
    t.string   "contract_stage_detail"
    t.string   "contract_stage_alert_id"
    t.decimal  "gst_hst",                                  precision: 10, scale: 3, default: "0.0"
    t.decimal  "pst",                                      precision: 10, scale: 3, default: "0.0"
    t.decimal  "subtotal",                                 precision: 10, scale: 3, default: "0.0"
    t.decimal  "deposit",                                  precision: 10, scale: 3, default: "0.0"
    t.decimal  "payment",                                  precision: 10, scale: 3, default: "0.0"
    t.decimal  "balance_due",                              precision: 10, scale: 3, default: "0.0"
    t.decimal  "total_cost",                               precision: 10, scale: 3, default: "0.0"
    t.boolean  "cost_hourly_selected"
    t.boolean  "packing_selected"
    t.boolean  "other_cost_selected"
    t.boolean  "surchage_selected"
    t.boolean  "flat_rate_selected"
    t.boolean  "discount_selected"
    t.boolean  "insurance_selected"
    t.boolean  "fuel_cost_selected"
    t.boolean  "payment_selected"
    t.boolean  "locked_move_record",                                                default: false
    t.integer  "user_locked_move_record_id"
    t.boolean  "approved",                                                          default: false
    t.boolean  "external_request",                                                  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "move_contract_number"
    t.string   "move_contract_name"
    t.text     "review_text",                limit: 65535
    t.string   "review_chosen_site"
    t.string   "review_link",                limit: 500
    t.date     "review_date"
    t.string   "review_status"
    t.boolean  "review_send",                                                       default: false
    t.boolean  "review2_send",                                                      default: false
    t.boolean  "review_thank_you_send",                                             default: false
    t.boolean  "complaint_response_send",                                           default: false
    t.boolean  "confirmation_send",                                                 default: false
    t.string   "token"
    t.string   "driver_token"
    t.index ["account_id"], name: "index_move_records_on_account_id", using: :btree
    t.index ["cargo_alert_id"], name: "move_records_cargo_alert_id_fk", using: :btree
    t.index ["cargo_type_id"], name: "move_records_cargo_type_id_fk", using: :btree
    t.index ["driver_token"], name: "index_move_records_on_driver_token", using: :btree
    t.index ["move_keyword_id"], name: "move_records_move_keyword_id_fk", using: :btree
    t.index ["move_referral_id"], name: "move_records_move_referral_id_fk", using: :btree
    t.index ["move_source_alert_id"], name: "move_records_move_source_alert_id_fk", using: :btree
    t.index ["move_source_id"], name: "move_records_move_source_id_fk", using: :btree
    t.index ["move_type_alert_id"], name: "move_records_move_type_alert_id_fk", using: :btree
    t.index ["move_type_id"], name: "move_records_move_type_id_fk", using: :btree
    t.index ["move_webpage_id"], name: "move_records_move_webpage_id_fk", using: :btree
    t.index ["old_system_id"], name: "index_move_records_on_old_system_id", using: :btree
    t.index ["token"], name: "index_move_records_on_token", using: :btree
    t.index ["user_id"], name: "move_records_user_id_fk", using: :btree
    t.index ["user_locked_move_record_id"], name: "move_records_user_locked_move_record_id_fk", using: :btree
  end

  create_table "move_referrals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_referrals_on_account_id", using: :btree
    t.index ["description"], name: "index_move_referrals_on_description", using: :btree
  end

  create_table "move_source_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_source_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_move_source_alerts_on_description", using: :btree
  end

  create_table "move_sources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_sources_on_account_id", using: :btree
    t.index ["description"], name: "index_move_sources_on_description", using: :btree
  end

  create_table "move_stage_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.index ["account_id"], name: "index_move_stage_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_move_stage_alerts_on_description", using: :btree
  end

  create_table "move_status_email_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "move_record_id"
    t.integer  "email_alert_id"
    t.integer  "move_status_id"
    t.integer  "contact_stage_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_status_email_alerts_on_account_id", using: :btree
    t.index ["email_alert_id"], name: "index_move_status_email_alerts_on_email_alert_id", using: :btree
    t.index ["move_record_id"], name: "move_status_email_alerts_move_record_id_fk", using: :btree
    t.index ["move_status_id"], name: "index_move_status_email_alerts_on_move_status_id", using: :btree
    t.index ["user_id"], name: "move_status_email_alerts_user_id_fk", using: :btree
  end

  create_table "move_statuses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["description"], name: "index_move_statuses_on_description", using: :btree
  end

  create_table "move_subsources", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "description"
    t.boolean  "active",         default: true
    t.integer  "account_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "move_source_id"
    t.index ["account_id"], name: "index_move_subsources_on_account_id", using: :btree
    t.index ["description"], name: "index_move_subsources_on_description", using: :btree
    t.index ["move_source_id"], name: "index_move_subsources_on_move_source_id", using: :btree
  end

  create_table "move_type_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_type_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_move_type_alerts_on_description", using: :btree
  end

  create_table "move_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_types_on_account_id", using: :btree
    t.index ["description"], name: "index_move_types_on_description", using: :btree
  end

  create_table "move_webpages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_move_webpages_on_account_id", using: :btree
    t.index ["description"], name: "index_move_webpages_on_description", using: :btree
  end

  create_table "packing_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_packing_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_packing_alerts_on_description", using: :btree
  end

  create_table "pay_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "hourly",     limit: 24, default: 0.0
    t.float    "monthly",    limit: 24, default: 0.0
    t.string   "detail"
    t.boolean  "active",                default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_pay_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_pay_commissions_on_user_id", using: :btree
  end

  create_table "payment_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_payment_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_payment_alerts_on_description", using: :btree
  end

  create_table "post_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_post_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_post_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_post_commission_move_records_on_user_id", using: :btree
  end

  create_table "post_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_post_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_post_commissions_on_user_id", using: :btree
  end

  create_table "provinces", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "quote_commission_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",             limit: 24, default: 0.0
    t.float    "storage",          limit: 24, default: 0.0
    t.float    "packing",          limit: 24, default: 0.0
    t.float    "insurance",        limit: 24, default: 0.0
    t.float    "other",            limit: 24, default: 0.0
    t.float    "blank",            limit: 24, default: 0.0
    t.float    "total_move",       limit: 24, default: 0.0
    t.float    "total_storage",    limit: 24, default: 0.0
    t.float    "total_packing",    limit: 24, default: 0.0
    t.float    "total_insurance",  limit: 24, default: 0.0
    t.float    "total_other",      limit: 24, default: 0.0
    t.float    "total_blank",      limit: 24, default: 0.0
    t.float    "total_commission", limit: 24, default: 0.0
    t.integer  "move_record_id"
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_quote_commission_move_records_on_account_id", using: :btree
    t.index ["move_record_id"], name: "index_quote_commission_move_records_on_move_record_id", using: :btree
    t.index ["user_id"], name: "index_quote_commission_move_records_on_user_id", using: :btree
  end

  create_table "quote_commissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.float    "move",         limit: 24, default: 0.0
    t.float    "storage",      limit: 24, default: 0.0
    t.float    "packing",      limit: 24, default: 0.0
    t.float    "insurance",    limit: 24, default: 0.0
    t.float    "other",        limit: 24, default: 0.0
    t.float    "blank",        limit: 24, default: 0.0
    t.float    "ld_move",      limit: 24, default: 0.0
    t.float    "ld_storage",   limit: 24, default: 0.0
    t.float    "ld_packing",   limit: 24, default: 0.0
    t.float    "ld_insurance", limit: 24, default: 0.0
    t.float    "ld_other",     limit: 24, default: 0.0
    t.float    "ld_blank",     limit: 24, default: 0.0
    t.boolean  "active",                  default: false
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_quote_commissions_on_account_id", using: :btree
    t.index ["user_id"], name: "index_quote_commissions_on_user_id", using: :btree
  end

  create_table "reminder_calendar_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "truck_id"
    t.integer  "author"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messages_truck_calendar_id"
    t.integer  "calendar_truck_group_id"
    t.index ["account_id"], name: "index_reminder_calendar_move_records_on_account_id", using: :btree
    t.index ["author"], name: "index_reminder_calendar_move_records_on_author", using: :btree
    t.index ["calendar_truck_group_id"], name: "reminder_calendar_move_records_calendar_truck_group_id_fk", using: :btree
    t.index ["messages_truck_calendar_id"], name: "reminder_calendar_move_records_messages_truck_calendar_id_fk", using: :btree
    t.index ["truck_id"], name: "index_reminder_calendar_move_records_on_truck_id", using: :btree
    t.index ["user_id"], name: "index_reminder_calendar_move_records_on_user_id", using: :btree
  end

  create_table "reminder_calendar_personals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "author"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messages_personal_calendar_id"
    t.index ["account_id"], name: "index_reminder_calendar_personals_on_account_id", using: :btree
    t.index ["author"], name: "index_reminder_calendar_personals_on_author", using: :btree
    t.index ["messages_personal_calendar_id"], name: "reminder_calendar_personals_messages_personal_calendar_id_fk", using: :btree
    t.index ["user_id"], name: "index_reminder_calendar_personals_on_user_id", using: :btree
  end

  create_table "reminder_calendar_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "subtask_staff_group_id"
    t.integer  "author"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "messages_task_calendar_id"
    t.integer  "calendar_staff_group_id"
    t.index ["account_id"], name: "index_reminder_calendar_tasks_on_account_id", using: :btree
    t.index ["author"], name: "index_reminder_calendar_tasks_on_author", using: :btree
    t.index ["calendar_staff_group_id"], name: "reminder_calendar_tasks_calendar_staff_group_id_fk", using: :btree
    t.index ["messages_task_calendar_id"], name: "reminder_calendar_tasks_messages_task_calendar_id_fk", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_reminder_calendar_tasks_on_subtask_staff_group_id", using: :btree
    t.index ["user_id"], name: "index_reminder_calendar_tasks_on_user_id", using: :btree
  end

  create_table "reminder_calendar_trucks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "truck_id"
    t.integer  "messages_truck_available_calendar_id"
    t.datetime "date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_reminder_calendar_trucks_on_account_id", using: :btree
    t.index ["messages_truck_available_calendar_id"], name: "index_reminder_calendar_on_messages_truck", using: :btree
    t.index ["truck_id"], name: "index_reminder_calendar_trucks_on_truck_id", using: :btree
    t.index ["user_id"], name: "index_reminder_calendar_trucks_on_user_id", using: :btree
  end

  create_table "review_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "account_id"
    t.string   "icon"
    t.string   "name"
    t.string   "link_url",                limit: 500
    t.integer  "calendar_truck_group_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["account_id"], name: "index_review_links_on_account_id", using: :btree
    t.index ["calendar_truck_group_id"], name: "index_review_links_on_calendar_truck_group_id", using: :btree
  end

  create_table "role_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "role_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "role_users_account_id_fk", using: :btree
    t.index ["role_id"], name: "role_users_role_id_fk", using: :btree
    t.index ["user_id"], name: "role_users_user_id_fk", using: :btree
  end

  create_table "roles", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.string   "name"
    t.string   "description"
    t.integer  "role_level",              default: 1
    t.integer  "calendar_staff_group_id"
    t.boolean  "mailbox",                 default: true
    t.boolean  "active",                  default: true
    t.boolean  "default",                 default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["account_id"], name: "roles_account_id_fk", using: :btree
  end

  create_table "rooms", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_rooms_on_name", using: :btree
  end

  create_table "staff_availables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_staff_availables_on_account_id", using: :btree
    t.index ["user_id"], name: "index_staff_availables_on_user_id", using: :btree
  end

  create_table "staff_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "subtask_staff_group_id"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal  "hours",                  precision: 10, scale: 2, default: "0.0"
    t.decimal  "rate",                   precision: 10, scale: 2, default: "0.0"
    t.decimal  "total_pay",              precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_staff_tasks_on_account_id", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_staff_tasks_on_subtask_staff_group_id", using: :btree
    t.index ["user_id"], name: "index_staff_tasks_on_user_id", using: :btree
  end

  create_table "subject_suggestions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_subject_suggestions_on_account_id", using: :btree
    t.index ["description"], name: "index_subject_suggestions_on_description", using: :btree
  end

  create_table "subtask_staff_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "account_id"
    t.integer  "calendar_staff_group_id"
    t.boolean  "mailbox",                 default: true
    t.boolean  "active",                  default: true
    t.integer  "role_id"
    t.integer  "role_level",              default: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "subtask_staff_groups_account_id_fk", using: :btree
    t.index ["calendar_staff_group_id"], name: "subtask_staff_groups_calendar_staff_group_id_fk", using: :btree
  end

  create_table "task_available_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "author"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "subtask_staff_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",            limit: 65535
    t.text     "notes",                  limit: 65535
    t.index ["account_id"], name: "index_task_available_calendars_on_account_id", using: :btree
    t.index ["author"], name: "task_available_calendars_author_fk", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_task_available_calendars_on_subtask_staff_group_id", using: :btree
    t.index ["user_id"], name: "index_task_available_calendars_on_user_id", using: :btree
  end

  create_table "task_calendar_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "messages_task_calendar_id"
    t.string   "file_path"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "task_calendar_attachments_account_id_fk", using: :btree
    t.index ["messages_task_calendar_id"], name: "task_calendar_attachments_messages_task_calendar_id_fk", using: :btree
  end

  create_table "task_message_task_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "subtask_staff_group_id"
    t.integer  "messages_task_calendar_id"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_task_message_task_calendars_on_account_id", using: :btree
    t.index ["messages_task_calendar_id"], name: "index_task_message_task_calendars_on_messages_task_calendar_id", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_task_message_task_calendars_on_subtask_staff_group_id", using: :btree
  end

  create_table "task_message_truck_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "subtask_staff_group_id"
    t.integer  "messages_truck_calendar_id"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_task_message_truck_calendars_on_account_id", using: :btree
    t.index ["messages_truck_calendar_id"], name: "index_task_message_truck_calendars_on_messages_truck_calendar_id", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_task_message_truck_calendars_on_subtask_staff_group_id", using: :btree
  end

  create_table "task_messages_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "subtask_staff_group_id"
    t.integer  "messages_move_record_id"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "marked",                  default: false
    t.boolean  "trash",                   default: false
    t.index ["account_id"], name: "index_task_messages_move_records_on_account_id", using: :btree
    t.index ["messages_move_record_id"], name: "index_task_messages_move_records_on_messages_move_record_id", using: :btree
    t.index ["subtask_staff_group_id"], name: "index_task_messages_move_records_on_subtask_staff_group_id", using: :btree
  end

  create_table "taxes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.decimal  "gst",                     precision: 10, scale: 2, default: "0.0"
    t.decimal  "pst",                     precision: 10, scale: 2, default: "0.0"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calendar_truck_group_id"
    t.integer  "account_id"
    t.index ["account_id"], name: "index_taxes_on_account_id", using: :btree
    t.index ["calendar_truck_group_id"], name: "index_taxes_on_calendar_truck_group_id", using: :btree
  end

  create_table "time_alerts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_time_alerts_on_account_id", using: :btree
    t.index ["description"], name: "index_time_alerts_on_description", using: :btree
  end

  create_table "truck_availables", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "truck_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "available"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_truck_availables_on_account_id", using: :btree
    t.index ["truck_id"], name: "index_truck_availables_on_truck_id", using: :btree
  end

  create_table "truck_calendar_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "messages_truck_calendar_id"
    t.string   "file_path"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "truck_calendar_attachments_account_id_fk", using: :btree
    t.index ["messages_truck_calendar_id"], name: "truck_calendar_attachments_messages_truck_calendar_id_fk", using: :btree
  end

  create_table "truck_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_truck_groups_on_account_id", using: :btree
    t.index ["description"], name: "index_truck_groups_on_description", using: :btree
  end

  create_table "truck_sizes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.boolean  "active",      default: true
    t.integer  "account_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_truck_sizes_on_account_id", using: :btree
    t.index ["description"], name: "index_truck_sizes_on_description", using: :btree
  end

  create_table "trucks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "description"
    t.string   "cell"
    t.string   "license"
    t.string   "year"
    t.string   "model"
    t.string   "cu_inch"
    t.string   "fuel"
    t.string   "phone"
    t.string   "fax"
    t.string   "registration"
    t.string   "make"
    t.string   "gvw"
    t.string   "serial_number"
    t.string   "insurance_date"
    t.string   "air_care_date"
    t.integer  "driver"
    t.string   "secondary_driver"
    t.string   "safety_date"
    t.string   "exterior_lenght"
    t.string   "exterior_width"
    t.string   "exterior_height"
    t.string   "interior_lenght"
    t.string   "interior_width"
    t.string   "interior_height"
    t.string   "inside_volume"
    t.string   "maximum_weight"
    t.string   "maximum_volume"
    t.string   "men"
    t.boolean  "piano",                          default: true
    t.boolean  "tailgate",                       default: true
    t.boolean  "active",                         default: true
    t.integer  "truck_group_id"
    t.integer  "truck_size_id"
    t.integer  "account_id"
    t.text     "bio",              limit: 65535
    t.text     "restrictions",     limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "size"
    t.index ["account_id"], name: "index_trucks_on_account_id", using: :btree
    t.index ["driver"], name: "trucks_driver_fk", using: :btree
    t.index ["truck_group_id"], name: "trucks_truck_group_id_fk", using: :btree
    t.index ["truck_size_id"], name: "trucks_truck_size_id_fk", using: :btree
  end

  create_table "user_message_task_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "messages_task_calendar_id"
    t.boolean  "readed"
    t.boolean  "marked",                    default: false
    t.boolean  "trash",                     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_user_message_task_calendars_on_account_id", using: :btree
    t.index ["messages_task_calendar_id"], name: "index_user_message_task_calendars_on_messages_task_calendar_id", using: :btree
    t.index ["user_id"], name: "index_user_message_task_calendars_on_user_id", using: :btree
  end

  create_table "user_message_truck_calendars", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "messages_truck_calendar_id"
    t.boolean  "readed"
    t.boolean  "marked",                     default: false
    t.boolean  "trash",                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_user_message_truck_calendars_on_account_id", using: :btree
    t.index ["messages_truck_calendar_id"], name: "index_user_message_truck_calendars_on_messages_truck_calendar_id", using: :btree
    t.index ["user_id"], name: "index_user_message_truck_calendars_on_user_id", using: :btree
  end

  create_table "user_messages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "message_id"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "marked",     default: false
    t.boolean  "trash",      default: false
    t.index ["account_id"], name: "index_user_messages_on_account_id", using: :btree
    t.index ["message_id"], name: "index_user_messages_on_message_id", using: :btree
    t.index ["user_id"], name: "index_user_messages_on_user_id", using: :btree
  end

  create_table "user_messages_move_records", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "messages_move_record_id"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "marked",                  default: false
    t.boolean  "trash",                   default: false
    t.index ["account_id"], name: "index_user_messages_move_records_on_account_id", using: :btree
    t.index ["messages_move_record_id"], name: "index_user_messages_move_records_on_messages_move_record_id", using: :btree
    t.index ["user_id"], name: "index_user_messages_move_records_on_user_id", using: :btree
  end

  create_table "user_messages_tasks", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.integer  "account_id"
    t.integer  "user_id"
    t.integer  "messages_task_id"
    t.boolean  "readed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "marked",           default: false
    t.boolean  "trash",            default: false
    t.index ["account_id"], name: "index_user_messages_tasks_on_account_id", using: :btree
    t.index ["messages_task_id"], name: "index_user_messages_tasks_on_messages_task_id", using: :btree
    t.index ["user_id"], name: "index_user_messages_tasks_on_user_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
    t.string   "dob"
    t.text     "bio",               limit: 65535
    t.string   "groups"
    t.string   "name"
    t.string   "title"
    t.string   "email_pers"
    t.string   "sin"
    t.string   "spouse"
    t.string   "children"
    t.string   "email"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "home_phone"
    t.string   "cell_phone"
    t.string   "work_phone"
    t.text     "address",           limit: 65535
    t.string   "building"
    t.string   "city"
    t.string   "locale"
    t.string   "province"
    t.string   "postal_code"
    t.integer  "account_id"
    t.boolean  "active",                          default: true
    t.string   "phone_pass"
    t.string   "vm_pass"
    t.string   "ext_no"
    t.boolean  "driver_commission",               default: false
    t.boolean  "move_commission",                 default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["account_id"], name: "index_users_on_account_id", using: :btree
  end

  add_foreign_key "access_alerts", "accounts", name: "access_alerts_account_id_fk"
  add_foreign_key "action_roles", "accounts", name: "action_roles_account_id_fk"
  add_foreign_key "action_roles", "actions", name: "action_roles_action_id_fk"
  add_foreign_key "action_roles", "roles", name: "action_roles_role_id_fk"
  add_foreign_key "action_users", "accounts", name: "action_users_account_id_fk"
  add_foreign_key "action_users", "actions", name: "action_users_action_id_fk"
  add_foreign_key "action_users", "users", name: "action_users_user_id_fk"
  add_foreign_key "aftercare_commission_move_records", "accounts", name: "aftercare_commission_move_records_account_id_fk"
  add_foreign_key "aftercare_commission_move_records", "move_records", name: "aftercare_commission_move_records_move_record_id_fk"
  add_foreign_key "aftercare_commission_move_records", "users", name: "aftercare_commission_move_records_user_id_fk"
  add_foreign_key "aftercare_commissions", "accounts", name: "aftercare_commissions_account_id_fk"
  add_foreign_key "aftercare_commissions", "users", name: "aftercare_commissions_user_id_fk"
  add_foreign_key "book_commission_move_records", "accounts", name: "book_commission_move_records_account_id_fk"
  add_foreign_key "book_commission_move_records", "move_records", name: "book_commission_move_records_move_record_id_fk"
  add_foreign_key "book_commission_move_records", "users", name: "book_commission_move_records_user_id_fk"
  add_foreign_key "book_commissions", "accounts", name: "book_commissions_account_id_fk"
  add_foreign_key "book_commissions", "users", name: "book_commissions_user_id_fk"
  add_foreign_key "calendar_staff_groups", "accounts", name: "calendar_staff_groups_account_id_fk"
  add_foreign_key "calendar_truck_groups", "accounts", name: "calendar_truck_groups_account_id_fk"
  add_foreign_key "cargo_alerts", "accounts", name: "cargo_alerts_account_id_fk"
  add_foreign_key "cargo_templates", "furnishings", name: "cargo_templates_furnishing_id_fk"
  add_foreign_key "cargo_types", "accounts", name: "cargo_types_account_id_fk"
  add_foreign_key "cities", "accounts", name: "cities_account_id_fk"
  add_foreign_key "clients", "accounts", name: "clients_account_id_fk"
  add_foreign_key "clients", "users", name: "clients_user_id_fk"
  add_foreign_key "company_commission_move_records", "accounts", name: "company_commission_move_records_account_id_fk"
  add_foreign_key "company_commission_move_records", "move_records", name: "company_commission_move_records_move_record_id_fk"
  add_foreign_key "config_parameters", "accounts", name: "config_parameters_account_id_fk"
  add_foreign_key "confirm_commission_move_records", "accounts", name: "confirm_commission_move_records_account_id_fk"
  add_foreign_key "confirm_commission_move_records", "move_records", name: "confirm_commission_move_records_move_record_id_fk"
  add_foreign_key "confirm_commission_move_records", "users", name: "confirm_commission_move_records_user_id_fk"
  add_foreign_key "confirm_commissions", "accounts", name: "confirm_commissions_account_id_fk"
  add_foreign_key "confirm_commissions", "users", name: "confirm_commissions_user_id_fk"
  add_foreign_key "contact_stages", "accounts"
  add_foreign_key "dispatch_commission_move_records", "accounts", name: "dispatch_commission_move_records_account_id_fk"
  add_foreign_key "dispatch_commission_move_records", "move_records", name: "dispatch_commission_move_records_move_record_id_fk"
  add_foreign_key "dispatch_commission_move_records", "users", name: "dispatch_commission_move_records_user_id_fk"
  add_foreign_key "dispatch_commissions", "accounts", name: "dispatch_commissions_account_id_fk"
  add_foreign_key "dispatch_commissions", "users", name: "dispatch_commissions_user_id_fk"
  add_foreign_key "driver_commission_move_records", "accounts", name: "driver_commission_move_records_account_id_fk"
  add_foreign_key "driver_commission_move_records", "move_records", name: "driver_commission_move_records_move_record_id_fk"
  add_foreign_key "driver_commission_move_records", "users", name: "driver_commission_move_records_user_id_fk"
  add_foreign_key "driver_commissions", "accounts", name: "driver_commissions_account_id_fk"
  add_foreign_key "driver_commissions", "users", name: "driver_commissions_user_id_fk"
  add_foreign_key "email_alerts", "accounts", name: "email_alerts_account_id_fk"
  add_foreign_key "email_messages_move_records", "accounts", name: "email_messages_move_records_account_id_fk"
  add_foreign_key "email_messages_move_records", "messages_move_records", name: "email_messages_move_records_messages_move_record_id_fk"
  add_foreign_key "email_messages_move_records", "users", name: "email_messages_move_records_user_id_fk"
  add_foreign_key "equipment_alerts", "accounts", name: "equipment_alerts_account_id_fk"
  add_foreign_key "furnishings", "rooms", name: "furnishings_room_id_fk"
  add_foreign_key "general_settings", "accounts"
  add_foreign_key "image_accounts", "accounts", name: "image_accounts_account_id_fk"
  add_foreign_key "image_profiles", "accounts", name: "image_profiles_account_id_fk"
  add_foreign_key "image_profiles", "users", name: "image_profiles_user_id_fk"
  add_foreign_key "image_trucks", "accounts", name: "image_trucks_account_id_fk"
  add_foreign_key "image_trucks", "trucks", name: "image_trucks_truck_id_fk"
  add_foreign_key "invoice_commission_move_records", "accounts", name: "invoice_commission_move_records_account_id_fk"
  add_foreign_key "invoice_commission_move_records", "move_records", name: "invoice_commission_move_records_move_record_id_fk"
  add_foreign_key "invoice_commission_move_records", "users", name: "invoice_commission_move_records_user_id_fk"
  add_foreign_key "invoice_commissions", "accounts", name: "invoice_commissions_account_id_fk"
  add_foreign_key "invoice_commissions", "users", name: "invoice_commissions_user_id_fk"
  add_foreign_key "lead_commission_move_records", "accounts", name: "lead_commission_move_records_account_id_fk"
  add_foreign_key "lead_commission_move_records", "move_records", name: "lead_commission_move_records_move_record_id_fk"
  add_foreign_key "lead_commission_move_records", "users", name: "lead_commission_move_records_user_id_fk"
  add_foreign_key "lead_commissions", "accounts", name: "lead_commissions_account_id_fk"
  add_foreign_key "lead_commissions", "users", name: "lead_commissions_user_id_fk"
  add_foreign_key "list_truck_groups", "accounts", name: "list_truck_groups_account_id_fk"
  add_foreign_key "list_truck_groups", "calendar_truck_groups", name: "list_truck_groups_calendar_truck_group_id_fk"
  add_foreign_key "list_truck_groups", "trucks", name: "list_truck_groups_truck_id_fk"
  add_foreign_key "locations", "accounts", name: "locations_account_id_fk"
  add_foreign_key "locations", "calendar_truck_groups", name: "locations_calendar_truck_group_id_fk"
  add_foreign_key "message_attachments", "accounts", name: "message_attachments_account_id_fk"
  add_foreign_key "message_attachments", "messages", name: "message_attachments_message_id_fk"
  add_foreign_key "messages", "accounts", name: "messages_account_id_fk"
  add_foreign_key "messages", "messages", column: "parent_id", name: "messages_parent_id_fk"
  add_foreign_key "messages", "users", name: "messages_user_id_fk"
  add_foreign_key "messages_move_record_attachments", "accounts", name: "messages_move_record_attachments_account_id_fk"
  add_foreign_key "messages_move_record_attachments", "messages_move_records", name: "messages_move_record_attachments_messages_move_record_id_fk"
  add_foreign_key "messages_move_records", "accounts", name: "messages_move_records_account_id_fk"
  add_foreign_key "messages_move_records", "messages_move_records", column: "parent_id", name: "messages_move_records_parent_id_fk"
  add_foreign_key "messages_move_records", "move_records", name: "messages_move_records_move_record_id_fk"
  add_foreign_key "messages_move_records", "users", name: "messages_move_records_user_id_fk"
  add_foreign_key "messages_staff_available_calendars", "accounts", name: "messages_staff_available_calendars_account_id_fk"
  add_foreign_key "messages_staff_available_calendars", "users", column: "staff_id", name: "messages_staff_available_calendars_staff_id_fk"
  add_foreign_key "messages_staff_available_calendars", "users", name: "messages_staff_available_calendars_user_id_fk"
  add_foreign_key "messages_task_attachments", "accounts", name: "messages_task_attachments_account_id_fk"
  add_foreign_key "messages_task_attachments", "messages_tasks", name: "messages_task_attachments_messages_task_id_fk"
  add_foreign_key "messages_task_calendars", "accounts", name: "messages_task_calendars_account_id_fk"
  add_foreign_key "messages_task_calendars", "calendar_staff_groups", name: "messages_task_calendars_calendar_staff_group_id_fk"
  add_foreign_key "messages_task_calendars", "messages_task_calendars", column: "parent_id", name: "messages_task_calendars_parent_id_fk"
  add_foreign_key "messages_task_calendars", "users", name: "messages_task_calendars_user_id_fk"
  add_foreign_key "messages_tasks", "accounts", name: "messages_tasks_account_id_fk"
  add_foreign_key "messages_tasks", "messages_tasks", column: "parent_id", name: "messages_tasks_parent_id_fk"
  add_foreign_key "messages_tasks", "subtask_staff_groups", column: "task_sender_id", name: "messages_tasks_task_sender_id_fk"
  add_foreign_key "messages_tasks", "subtask_staff_groups", name: "messages_tasks_subtask_staff_group_id_fk"
  add_foreign_key "messages_tasks", "users", name: "messages_tasks_user_id_fk"
  add_foreign_key "messages_truck_available_calendars", "accounts", name: "messages_truck_available_calendars_account_id_fk"
  add_foreign_key "messages_truck_available_calendars", "trucks", name: "messages_truck_available_calendars_truck_id_fk"
  add_foreign_key "messages_truck_available_calendars", "users", name: "messages_truck_available_calendars_user_id_fk"
  add_foreign_key "messages_truck_calendars", "accounts", name: "messages_truck_calendars_account_id_fk"
  add_foreign_key "messages_truck_calendars", "calendar_truck_groups", name: "messages_truck_calendars_calendar_truck_group_id_fk"
  add_foreign_key "messages_truck_calendars", "messages_truck_calendars", column: "parent_id", name: "messages_truck_calendars_parent_id_fk"
  add_foreign_key "messages_truck_calendars", "users", name: "messages_truck_calendars_user_id_fk"
  add_foreign_key "move_keywords", "accounts", name: "move_keywords_account_id_fk"
  add_foreign_key "move_record_cargos", "accounts", name: "move_record_cargos_account_id_fk"
  add_foreign_key "move_record_cargos", "move_records", name: "move_record_cargos_move_record_id_fk"
  add_foreign_key "move_record_clients", "accounts", name: "move_record_clients_account_id_fk"
  add_foreign_key "move_record_clients", "clients", name: "move_record_clients_client_id_fk"
  add_foreign_key "move_record_clients", "move_records", name: "move_record_clients_move_record_id_fk"
  add_foreign_key "move_record_cost_hourlies", "accounts", name: "move_record_cost_hourlies_account_id_fk"
  add_foreign_key "move_record_cost_hourlies", "move_records", name: "move_record_cost_hourlies_move_record_id_fk"
  add_foreign_key "move_record_dates", "accounts", name: "move_record_dates_account_id_fk"
  add_foreign_key "move_record_dates", "move_records", name: "move_record_dates_move_record_id_fk"
  add_foreign_key "move_record_default_settings", "access_alerts", column: "destination_access_alert_id", name: "move_record_default_settings_destination_access_alert_id_fk"
  add_foreign_key "move_record_default_settings", "access_alerts", column: "origin_access_alert_id", name: "move_record_default_settings_origin_access_alert_id_fk"
  add_foreign_key "move_record_default_settings", "accounts", name: "move_record_default_settings_account_id_fk"
  add_foreign_key "move_record_default_settings", "cargo_alerts", name: "move_record_default_settings_cargo_alert_id_fk"
  add_foreign_key "move_record_default_settings", "cargo_types", name: "move_record_default_settings_cargo_type_id_fk"
  add_foreign_key "move_record_default_settings", "equipment_alerts", name: "move_record_default_settings_equipment_alert_id_fk"
  add_foreign_key "move_record_default_settings", "move_keywords", name: "move_record_default_settings_move_keyword_id_fk"
  add_foreign_key "move_record_default_settings", "move_referrals", name: "move_record_default_settings_move_referral_id_fk"
  add_foreign_key "move_record_default_settings", "move_source_alerts", name: "move_record_default_settings_move_source_alert_id_fk"
  add_foreign_key "move_record_default_settings", "move_sources", name: "move_record_default_settings_move_source_id_fk"
  add_foreign_key "move_record_default_settings", "move_stage_alerts", column: "move_stage_alerts_id"
  add_foreign_key "move_record_default_settings", "move_type_alerts", name: "move_record_default_settings_move_type_alert_id_fk"
  add_foreign_key "move_record_default_settings", "move_types", name: "move_record_default_settings_move_type_id_fk"
  add_foreign_key "move_record_default_settings", "move_webpages", name: "move_record_default_settings_move_webpage_id_fk"
  add_foreign_key "move_record_default_settings", "packing_alerts", name: "move_record_default_settings_packing_alert_id_fk"
  add_foreign_key "move_record_default_settings", "payment_alerts", name: "move_record_default_settings_payment_alert_id_fk"
  add_foreign_key "move_record_default_settings", "time_alerts", name: "move_record_default_settings_time_alert_id_fk"
  add_foreign_key "move_record_default_settings", "trucks", name: "move_record_default_settings_truck_id_fk"
  add_foreign_key "move_record_discounts", "accounts", name: "move_record_discounts_account_id_fk"
  add_foreign_key "move_record_discounts", "move_records", name: "move_record_discounts_move_record_id_fk"
  add_foreign_key "move_record_flat_rates", "accounts", name: "move_record_flat_rates_account_id_fk"
  add_foreign_key "move_record_flat_rates", "move_records", name: "move_record_flat_rates_move_record_id_fk"
  add_foreign_key "move_record_fuel_costs", "accounts", name: "move_record_fuel_costs_account_id_fk"
  add_foreign_key "move_record_fuel_costs", "move_records", name: "move_record_fuel_costs_move_record_id_fk"
  add_foreign_key "move_record_insurances", "accounts", name: "move_record_insurances_account_id_fk"
  add_foreign_key "move_record_insurances", "move_records", name: "move_record_insurances_move_record_id_fk"
  add_foreign_key "move_record_location_destinations", "accounts", name: "move_record_location_destinations_account_id_fk"
  add_foreign_key "move_record_location_destinations", "locations", name: "move_record_location_destinations_location_id_fk"
  add_foreign_key "move_record_location_destinations", "move_records", name: "move_record_location_destinations_move_record_id_fk"
  add_foreign_key "move_record_location_origins", "accounts", name: "move_record_location_origins_account_id_fk"
  add_foreign_key "move_record_location_origins", "locations", name: "move_record_location_origins_location_id_fk"
  add_foreign_key "move_record_location_origins", "move_records", name: "move_record_location_origins_move_record_id_fk"
  add_foreign_key "move_record_notes", "accounts", name: "move_record_notes_account_id_fk"
  add_foreign_key "move_record_notes", "move_records", name: "move_record_notes_move_record_id_fk"
  add_foreign_key "move_record_other_costs", "accounts", name: "move_record_other_costs_account_id_fk"
  add_foreign_key "move_record_other_costs", "move_records", name: "move_record_other_costs_move_record_id_fk"
  add_foreign_key "move_record_packings", "accounts", name: "move_record_packings_account_id_fk"
  add_foreign_key "move_record_packings", "move_records", name: "move_record_packings_move_record_id_fk"
  add_foreign_key "move_record_payments", "accounts", name: "move_record_payments_account_id_fk"
  add_foreign_key "move_record_payments", "move_records", name: "move_record_payments_move_record_id_fk"
  add_foreign_key "move_record_submits", "accounts", name: "move_record_submits_account_id_fk"
  add_foreign_key "move_record_submits", "move_records", name: "move_record_submits_move_record_id_fk"
  add_foreign_key "move_record_surcharges", "accounts", name: "move_record_surcharges_account_id_fk"
  add_foreign_key "move_record_surcharges", "move_records", name: "move_record_surcharges_move_record_id_fk"
  add_foreign_key "move_record_trucks", "accounts", name: "move_record_trucks_account_id_fk"
  add_foreign_key "move_record_trucks", "move_records", name: "move_record_trucks_move_record_id_fk"
  add_foreign_key "move_record_trucks", "trucks", name: "move_record_trucks_truck_id_fk"
  add_foreign_key "move_record_trucks", "users", column: "lead", name: "move_record_trucks_lead_fk"
  add_foreign_key "move_record_trucks", "users", column: "mover_2", name: "move_record_trucks_mover_2_fk"
  add_foreign_key "move_record_trucks", "users", column: "mover_3", name: "move_record_trucks_mover_3_fk"
  add_foreign_key "move_record_trucks", "users", column: "mover_4", name: "move_record_trucks_mover_4_fk"
  add_foreign_key "move_record_trucks", "users", column: "mover_5", name: "move_record_trucks_mover_5_fk"
  add_foreign_key "move_record_trucks", "users", column: "mover_6", name: "move_record_trucks_mover_6_fk"
  add_foreign_key "move_records", "accounts", name: "move_records_account_id_fk"
  add_foreign_key "move_records", "move_types", name: "move_records_move_type_id_fk"
  add_foreign_key "move_records", "users", column: "user_locked_move_record_id", name: "move_records_user_locked_move_record_id_fk"
  add_foreign_key "move_records", "users", name: "move_records_user_id_fk"
  add_foreign_key "move_referrals", "accounts", name: "move_referrals_account_id_fk"
  add_foreign_key "move_source_alerts", "accounts", name: "move_source_alerts_account_id_fk"
  add_foreign_key "move_sources", "accounts", name: "move_sources_account_id_fk"
  add_foreign_key "move_stage_alerts", "accounts"
  add_foreign_key "move_status_email_alerts", "accounts", name: "move_status_email_alerts_account_id_fk"
  add_foreign_key "move_status_email_alerts", "email_alerts", name: "move_status_email_alerts_email_alert_id_fk"
  add_foreign_key "move_status_email_alerts", "move_records", name: "move_status_email_alerts_move_record_id_fk"
  add_foreign_key "move_status_email_alerts", "move_statuses", name: "move_status_email_alerts_move_status_id_fk"
  add_foreign_key "move_status_email_alerts", "users", name: "move_status_email_alerts_user_id_fk"
  add_foreign_key "move_subsources", "accounts"
  add_foreign_key "move_type_alerts", "accounts", name: "move_type_alerts_account_id_fk"
  add_foreign_key "move_types", "accounts", name: "move_types_account_id_fk"
  add_foreign_key "move_webpages", "accounts", name: "move_webpages_account_id_fk"
  add_foreign_key "packing_alerts", "accounts", name: "packing_alerts_account_id_fk"
  add_foreign_key "pay_commissions", "accounts", name: "pay_commissions_account_id_fk"
  add_foreign_key "pay_commissions", "users", name: "pay_commissions_user_id_fk"
  add_foreign_key "payment_alerts", "accounts", name: "payment_alerts_account_id_fk"
  add_foreign_key "post_commission_move_records", "accounts", name: "post_commission_move_records_account_id_fk"
  add_foreign_key "post_commission_move_records", "move_records", name: "post_commission_move_records_move_record_id_fk"
  add_foreign_key "post_commission_move_records", "users", name: "post_commission_move_records_user_id_fk"
  add_foreign_key "post_commissions", "accounts", name: "post_commissions_account_id_fk"
  add_foreign_key "post_commissions", "users", name: "post_commissions_user_id_fk"
  add_foreign_key "quote_commission_move_records", "accounts", name: "quote_commission_move_records_account_id_fk"
  add_foreign_key "quote_commission_move_records", "move_records", name: "quote_commission_move_records_move_record_id_fk"
  add_foreign_key "quote_commission_move_records", "users", name: "quote_commission_move_records_user_id_fk"
  add_foreign_key "quote_commissions", "accounts", name: "quote_commissions_account_id_fk"
  add_foreign_key "quote_commissions", "users", name: "quote_commissions_user_id_fk"
  add_foreign_key "reminder_calendar_move_records", "accounts", name: "reminder_calendar_move_records_account_id_fk"
  add_foreign_key "reminder_calendar_move_records", "calendar_truck_groups", name: "reminder_calendar_move_records_calendar_truck_group_id_fk"
  add_foreign_key "reminder_calendar_move_records", "messages_truck_calendars", name: "reminder_calendar_move_records_messages_truck_calendar_id_fk"
  add_foreign_key "reminder_calendar_move_records", "trucks", name: "reminder_calendar_move_records_truck_id_fk"
  add_foreign_key "reminder_calendar_move_records", "users", column: "author", name: "reminder_calendar_move_records_author_fk"
  add_foreign_key "reminder_calendar_move_records", "users", name: "reminder_calendar_move_records_user_id_fk"
  add_foreign_key "reminder_calendar_personals", "accounts", name: "reminder_calendar_personals_account_id_fk"
  add_foreign_key "reminder_calendar_personals", "messages_staff_available_calendars", column: "messages_personal_calendar_id", name: "reminder_calendar_personals_messages_personal_calendar_id_fk"
  add_foreign_key "reminder_calendar_personals", "users", column: "author", name: "reminder_calendar_personals_author_fk"
  add_foreign_key "reminder_calendar_personals", "users", name: "reminder_calendar_personals_user_id_fk"
  add_foreign_key "reminder_calendar_tasks", "accounts", name: "reminder_calendar_tasks_account_id_fk"
  add_foreign_key "reminder_calendar_tasks", "calendar_staff_groups", name: "reminder_calendar_tasks_calendar_staff_group_id_fk"
  add_foreign_key "reminder_calendar_tasks", "messages_task_calendars", name: "reminder_calendar_tasks_messages_task_calendar_id_fk"
  add_foreign_key "reminder_calendar_tasks", "subtask_staff_groups", name: "reminder_calendar_tasks_subtask_staff_group_id_fk"
  add_foreign_key "reminder_calendar_tasks", "users", column: "author", name: "reminder_calendar_tasks_author_fk"
  add_foreign_key "reminder_calendar_tasks", "users", name: "reminder_calendar_tasks_user_id_fk"
  add_foreign_key "reminder_calendar_trucks", "accounts", name: "reminder_calendar_trucks_account_id_fk"
  add_foreign_key "reminder_calendar_trucks", "messages_truck_available_calendars", name: "reminder_calendar_trucks_messages_truck_available_calendar_id_fk"
  add_foreign_key "reminder_calendar_trucks", "trucks", name: "reminder_calendar_trucks_truck_id_fk"
  add_foreign_key "reminder_calendar_trucks", "users", name: "reminder_calendar_trucks_user_id_fk"
  add_foreign_key "role_users", "accounts", name: "role_users_account_id_fk"
  add_foreign_key "role_users", "roles", name: "role_users_role_id_fk"
  add_foreign_key "role_users", "users", name: "role_users_user_id_fk"
  add_foreign_key "roles", "accounts", name: "roles_account_id_fk"
  add_foreign_key "staff_availables", "accounts", name: "staff_availables_account_id_fk"
  add_foreign_key "staff_availables", "users", name: "staff_availables_user_id_fk"
  add_foreign_key "staff_tasks", "accounts", name: "staff_tasks_account_id_fk"
  add_foreign_key "staff_tasks", "subtask_staff_groups", name: "staff_tasks_subtask_staff_group_id_fk"
  add_foreign_key "staff_tasks", "users", name: "staff_tasks_user_id_fk"
  add_foreign_key "subject_suggestions", "accounts", name: "subject_suggestions_account_id_fk"
  add_foreign_key "subtask_staff_groups", "accounts", name: "subtask_staff_groups_account_id_fk"
  add_foreign_key "subtask_staff_groups", "calendar_staff_groups", name: "subtask_staff_groups_calendar_staff_group_id_fk"
  add_foreign_key "task_available_calendars", "accounts", name: "task_available_calendars_account_id_fk"
  add_foreign_key "task_available_calendars", "subtask_staff_groups", name: "task_available_calendars_subtask_staff_group_id_fk"
  add_foreign_key "task_available_calendars", "users", column: "author", name: "task_available_calendars_author_fk"
  add_foreign_key "task_available_calendars", "users", name: "task_available_calendars_user_id_fk"
  add_foreign_key "task_calendar_attachments", "accounts", name: "task_calendar_attachments_account_id_fk"
  add_foreign_key "task_calendar_attachments", "messages_task_calendars", name: "task_calendar_attachments_messages_task_calendar_id_fk"
  add_foreign_key "task_message_task_calendars", "accounts", name: "task_message_task_calendars_account_id_fk"
  add_foreign_key "task_message_task_calendars", "messages_task_calendars", name: "task_message_task_calendars_messages_task_calendar_id_fk"
  add_foreign_key "task_message_task_calendars", "subtask_staff_groups", name: "task_message_task_calendars_subtask_staff_group_id_fk"
  add_foreign_key "task_message_truck_calendars", "accounts", name: "task_message_truck_calendars_account_id_fk"
  add_foreign_key "task_message_truck_calendars", "messages_truck_calendars", name: "task_message_truck_calendars_messages_truck_calendar_id_fk"
  add_foreign_key "task_message_truck_calendars", "subtask_staff_groups", name: "task_message_truck_calendars_subtask_staff_group_id_fk"
  add_foreign_key "task_messages_move_records", "accounts", name: "task_messages_move_records_account_id_fk"
  add_foreign_key "task_messages_move_records", "messages_move_records", name: "task_messages_move_records_messages_move_record_id_fk"
  add_foreign_key "task_messages_move_records", "subtask_staff_groups", name: "task_messages_move_records_subtask_staff_group_id_fk"
  add_foreign_key "time_alerts", "accounts", name: "time_alerts_account_id_fk"
  add_foreign_key "truck_availables", "accounts", name: "truck_availables_account_id_fk"
  add_foreign_key "truck_availables", "trucks", name: "truck_availables_truck_id_fk"
  add_foreign_key "truck_calendar_attachments", "accounts", name: "truck_calendar_attachments_account_id_fk"
  add_foreign_key "truck_calendar_attachments", "messages_truck_calendars", name: "truck_calendar_attachments_messages_truck_calendar_id_fk"
  add_foreign_key "truck_groups", "accounts", name: "truck_groups_account_id_fk"
  add_foreign_key "truck_sizes", "accounts", name: "truck_sizes_account_id_fk"
  add_foreign_key "trucks", "accounts", name: "trucks_account_id_fk"
  add_foreign_key "trucks", "truck_groups", name: "trucks_truck_group_id_fk"
  add_foreign_key "trucks", "truck_sizes", name: "trucks_truck_size_id_fk"
  add_foreign_key "trucks", "users", column: "driver", name: "trucks_driver_fk"
  add_foreign_key "user_message_task_calendars", "accounts", name: "user_message_task_calendars_account_id_fk"
  add_foreign_key "user_message_task_calendars", "messages_task_calendars", name: "user_message_task_calendars_messages_task_calendar_id_fk"
  add_foreign_key "user_message_task_calendars", "users", name: "user_message_task_calendars_user_id_fk"
  add_foreign_key "user_message_truck_calendars", "accounts", name: "user_message_truck_calendars_account_id_fk"
  add_foreign_key "user_message_truck_calendars", "messages_truck_calendars", name: "user_message_truck_calendars_messages_truck_calendar_id_fk"
  add_foreign_key "user_message_truck_calendars", "users", name: "user_message_truck_calendars_user_id_fk"
  add_foreign_key "user_messages", "accounts", name: "user_messages_account_id_fk"
  add_foreign_key "user_messages", "messages", name: "user_messages_message_id_fk"
  add_foreign_key "user_messages", "users", name: "user_messages_user_id_fk"
  add_foreign_key "user_messages_move_records", "accounts", name: "user_messages_move_records_account_id_fk"
  add_foreign_key "user_messages_move_records", "messages_move_records", name: "user_messages_move_records_messages_move_record_id_fk"
  add_foreign_key "user_messages_move_records", "users", name: "user_messages_move_records_user_id_fk"
  add_foreign_key "user_messages_tasks", "accounts", name: "user_messages_tasks_account_id_fk"
  add_foreign_key "user_messages_tasks", "messages_tasks", name: "user_messages_tasks_messages_task_id_fk"
  add_foreign_key "user_messages_tasks", "users", name: "user_messages_tasks_user_id_fk"
  add_foreign_key "users", "accounts", name: "users_account_id_fk"
end
