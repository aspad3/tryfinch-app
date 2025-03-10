class CreatePayrollPaymentStatements < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_payment_statements, id: :uuid do |t|
      t.uuid :payment_id, null: false
      t.uuid :individual_id, null: false
      t.string :statement_type
      t.string :payment_method
      t.decimal :total_hours, precision: 10, scale: 2
      t.decimal :gross_pay_amount, precision: 15, scale: 2
      t.string :gross_pay_currency
      t.decimal :net_pay_amount, precision: 15, scale: 2
      t.string :net_pay_currency
      t.jsonb :earnings, default: []
      t.jsonb :taxes, default: []
      t.jsonb :employee_deductions, default: []
      t.jsonb :employer_contributions, default: []
      t.timestamps
    end
  end
end

