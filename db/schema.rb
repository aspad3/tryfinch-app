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
  enable_extension "plpgsql"

  create_table "archive_payrolls", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "file_path"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_archive_payrolls_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.integer "user_id"
    t.text "access_token"
    t.jsonb "response_finch"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_customers_on_user_id"
  end

  create_table "payroll_employees", force: :cascade do |t|
    t.string "payroll_id"
    t.string "employee_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "middle_name"
    t.string "title"
    t.string "employment_type"
    t.string "employment_subtype"
    t.date "start_date"
    t.date "end_date"
    t.date "latest_rehire_date"
    t.boolean "is_active"
    t.text "location"
    t.decimal "income_amount"
    t.string "income_currency"
    t.string "income_unit"
    t.index ["payroll_id", "employee_id"], name: "index_payroll_employees_on_payroll_id_and_employee_id", unique: true
  end

  create_table "payroll_reports", force: :cascade do |t|
    t.integer "customer_id"
    t.string "payroll_id"
    t.date "pay_period_start"
    t.date "pay_period_end"
    t.date "pay_date"
    t.integer "gross_pay"
    t.integer "net_pay"
    t.string "currency"
    t.text "individual_ids", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_payroll_reports_on_customer_id"
    t.index ["payroll_id"], name: "index_payroll_reports_on_payroll_id", unique: true
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

  add_foreign_key "archive_payrolls", "customers"
end
