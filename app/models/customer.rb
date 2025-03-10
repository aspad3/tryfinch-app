class Customer < ApplicationRecord
  belongs_to :user
  has_many :archive_payrolls
  has_many :payroll_payments

  delegate :fullname, :email, to: :user, allow_nil: true

  def customer_id
    id
  end

  def customer_name
    fullname
  end

  def token_valid?
    return false unless access_token.presence

    response = Tryfinch::API::SessionConnect.introspect(access_token)
    response&.dig("connection_status", "status") == 'connected'
  rescue StandardError => e
    Rails.logger.error("Customer##{id} token validation failed: #{e.message}")
    false
  end

  def disconnect
    return false unless access_token.presence

    response = Tryfinch::API::SessionConnect.disconnect(access_token)
    return false unless response.present?

    update(
      access_token: nil,
      meta_data: nil,
      provider_data: nil
    )
  rescue StandardError => e
    Rails.logger.error("Customer##{id} disconnect failed: #{e.message}")
    false
  end
end
