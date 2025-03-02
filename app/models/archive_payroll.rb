class ArchivePayroll < ApplicationRecord
  belongs_to :customer

  validates :customer_id, :file_path, :start_date, :end_date, presence: true

  def self.recent_for(customer)
    where(customer: customer).order(created_at: :desc)
  end
end
