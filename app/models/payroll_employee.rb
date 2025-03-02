class PayrollEmployee < ApplicationRecord
  validates :employee_id, presence: true, uniqueness: { scope: :payroll_id }
end
