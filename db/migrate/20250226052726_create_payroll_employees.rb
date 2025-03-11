class CreatePayrollEmployees < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_employees, id: false do |t|
      t.uuid :individual_id, null: false
      t.string :first_name, null: false
      t.string :middle_name
      t.string :last_name, null: false
      t.string :title
      t.uuid :manager_id
      t.string :department_name
      t.string :employment_type
      t.string :employment_subtype
      t.date :start_date
      t.date :end_date
      t.date :latest_rehire_date
      t.boolean :is_active, default: true
      t.string :employment_status
      t.string :class_code
      t.jsonb :location, default: {}
      t.jsonb :income, default: {}
      t.jsonb :income_history, default: []
      t.jsonb :custom_fields, default: []
      t.index [:individual_id], unique: true, name: 'index_payroll_employees_on_individual_id'
    end
  end
end
