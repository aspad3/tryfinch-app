class PayrollPayment < ApplicationRecord
  belongs_to :customer, optional: true
  has_many :payroll_payment_statements, primary_key: :payroll_id, foreign_key: :payment_id
  has_many :payroll_employees, through: :payroll_payment_statements
end
