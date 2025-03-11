class PayrollStatementService
  def initialize(access_token, payment)
    @access_token = access_token
    @payment = payment
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def fetch_and_store_statements
    statements = fetch_statement

    statements['responses'].each do |response|
      next unless response['code'] == 200

      response['body']['pay_statements'].each do |pay_statement|
        PayrollPaymentStatement.create!(
          payment_id: response['payment_id'],
          individual_id: pay_statement['individual_id'],
          statement_type: pay_statement['type'],
          payment_method: pay_statement['payment_method'],
          total_hours: pay_statement['total_hours'],
          gross_pay_amount: pay_statement['gross_pay']['amount'],
          gross_pay_currency: pay_statement['gross_pay']['currency'],
          net_pay_amount: pay_statement['net_pay']['amount'],
          net_pay_currency: pay_statement['net_pay']['currency'],
          earnings: pay_statement['earnings'],
          taxes: pay_statement['taxes'],
          employee_deductions: pay_statement['employee_deductions'],
          employer_contributions: pay_statement['employer_contributions']
        )
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def fetch_statement
    Tryfinch::API::PayrollStatement.new(customer_token: @access_token,
                                        payment_id: @payment.payroll_id).fetch_statement
  end
end
