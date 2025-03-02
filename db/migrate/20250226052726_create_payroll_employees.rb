class CreatePayrollEmployees < ActiveRecord::Migration[7.1]
  def change
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
  end
end