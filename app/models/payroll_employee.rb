class PayrollEmployee < ApplicationRecord
  self.primary_key = 'individual_id'

  has_many :payroll_payment_statements, foreign_key: 'individual_id', primary_key: 'individual_id'
  validates :individual_id, presence: true
end
