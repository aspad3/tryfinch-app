class ArchivePayroll < ApplicationRecord
  belongs_to :customer

  validates :start_date, :end_date, presence: true
  validate :valid_date_range

  def self.recent_for(customer)
    where(customer: customer).order(created_at: :desc)
  end

  private

  def valid_date_range
    return if start_date.nil? || end_date.nil?

    errors.add(:end_date, 'cannot be earlier than the start date') if end_date < start_date

    return unless (end_date - start_date).to_i > 30

    errors.add(:end_date, 'must not exceed 30 days from the start date')
  end
end
