class CreatePayrollReports < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_reports do |t|
      t.integer :customer_id
      t.string :payroll_id
      t.date :pay_period_start
      t.date :pay_period_end
      t.date :pay_date
      t.integer :gross_pay
      t.integer :net_pay
      t.string :currency
      t.text :individual_ids, array: true, default: []

      t.timestamps
    end

    add_index :payroll_reports, :payroll_id, unique: true
    add_index :payroll_reports, :customer_id
  end
end
