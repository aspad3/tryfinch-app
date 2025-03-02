class PayrollReport < ApplicationRecord
  belongs_to :customer
  has_many :payroll_employees, primary_key: :payroll_id, foreign_key: :payroll_id
end
