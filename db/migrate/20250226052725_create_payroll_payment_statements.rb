class CreatePayrollPaymentStatements < ActiveRecord::Migration[7.1]
  def change
    create_table :payroll_payment_statements, id: :uuid do |t|
      t.uuid :payment_id, null: false
      t.uuid :individual_id, null: false
      t.string :statement_type, null: false
      t.string :payment_method, null: false
      t.decimal :total_hours, precision: 10, scale: 2, null: false
      t.decimal :gross_pay_amount, precision: 15, scale: 2, null: false
      t.string :gross_pay_currency, null: false
      t.decimal :net_pay_amount, precision: 15, scale: 2, null: false
      t.string :net_pay_currency, null: false
      t.jsonb :earnings, null: false, default: []
      t.jsonb :taxes, null: false, default: []
      t.jsonb :employee_deductions, null: false, default: []
      t.jsonb :employer_contributions, null: false, default: []
      t.timestamps
    end
  end
end

