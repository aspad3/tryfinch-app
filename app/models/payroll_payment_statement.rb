class PayrollPaymentStatement < ApplicationRecord
  belongs_to :payroll_employee, foreign_key: 'individual_id', primary_key: 'individual_id', optional: true
end
