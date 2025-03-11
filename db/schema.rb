# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_03_02_211932) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "archive_payrolls", force: :cascade do |t|
    t.uuid "customer_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_archive_payrolls_on_customer_id"
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "access_token"
    t.jsonb "meta_data"
    t.jsonb "provider_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "payroll_employees", id: false, force: :cascade do |t|
    t.uuid "individual_id", null: false
    t.string "first_name", null: false
    t.string "middle_name"
    t.string "last_name", null: false
    t.string "title"
    t.uuid "manager_id"
    t.string "department_name"
    t.string "employment_type"
    t.string "employment_subtype"
    t.date "start_date"
    t.date "end_date"
    t.date "latest_rehire_date"
    t.boolean "is_active", default: true
    t.string "employment_status"
    t.string "class_code"
    t.jsonb "location", default: {}
    t.jsonb "income", default: {}
    t.jsonb "income_history", default: []
    t.jsonb "custom_fields", default: []
    t.index ["individual_id"], name: "index_payroll_employees_on_individual_id", unique: true
  end

  create_table "payroll_payment_statements", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "payment_id", null: false
    t.uuid "individual_id", null: false
    t.string "statement_type"
    t.string "payment_method"
    t.decimal "total_hours", precision: 10, scale: 2
    t.decimal "gross_pay_amount", precision: 15, scale: 2
    t.string "gross_pay_currency"
    t.decimal "net_pay_amount", precision: 15, scale: 2
    t.string "net_pay_currency"
    t.jsonb "earnings", default: []
    t.jsonb "taxes", default: []
    t.jsonb "employee_deductions", default: []
    t.jsonb "employer_contributions", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payroll_payments", force: :cascade do |t|
    t.uuid "customer_id"
    t.uuid "payroll_id"
    t.date "pay_period_start"
    t.date "pay_period_end"
    t.date "pay_date"
    t.date "debit_date"
    t.decimal "company_debit_amount", precision: 15, scale: 2
    t.string "company_debit_currency"
    t.decimal "gross_pay_amount", precision: 15, scale: 2
    t.string "gross_pay_currency"
    t.decimal "net_pay_amount", precision: 15, scale: 2
    t.string "net_pay_currency"
    t.decimal "employer_taxes_amount", precision: 15, scale: 2
    t.string "employer_taxes_currency"
    t.decimal "employee_taxes_amount", precision: 15, scale: 2
    t.string "employee_taxes_currency"
    t.jsonb "individual_ids", default: []
    t.jsonb "pay_group_ids", default: []
    t.jsonb "pay_frequencies", default: []
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payroll_payments_on_customer_id"
    t.index ["payroll_id"], name: "index_payroll_payments_on_payroll_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
