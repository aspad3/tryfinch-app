class CreatePayrollPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_payments do |t|
      t.uuid :customer_id
      t.uuid :payroll_id
      t.date :pay_period_start
      t.date :pay_period_end
      t.date :pay_date
      t.date :debit_date
      t.decimal :company_debit_amount, precision: 15, scale: 2
      t.string :company_debit_currency
      t.decimal :gross_pay_amount, precision: 15, scale: 2
      t.string :gross_pay_currency
      t.decimal :net_pay_amount, precision: 15, scale: 2
      t.string :net_pay_currency
      t.decimal :employer_taxes_amount, precision: 15, scale: 2
      t.string :employer_taxes_currency
      t.decimal :employee_taxes_amount, precision: 15, scale: 2
      t.string :employee_taxes_currency
      t.jsonb :individual_ids, default: []
      t.jsonb :pay_group_ids, default: []
      t.jsonb :pay_frequencies, default: []
      t.timestamps
    end

    add_index :payroll_payments, :customer_id
    add_index :payroll_payments, :payroll_id, unique: true
  end
end
