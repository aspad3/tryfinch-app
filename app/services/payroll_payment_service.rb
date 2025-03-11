class PayrollPaymentService
  def initialize(customer, start_date, end_date)
    @customer = customer
    @access_token = customer.access_token
    @start_date = start_date
    @end_date = end_date
  end

  def fetch_and_store_payroll
    fetch_payroll_data.each do |payroll|
      next if payroll.blank?

      payment = find_or_initialize_payment(payroll)

      if payment.new_record?
        process_new_payment(payment)
      else
        payment.save
      end
    end
  end

  private

  def find_or_initialize_payment(payroll)
    PayrollPayment.find_or_initialize_by(payroll_id: payroll['id'], customer_id: @customer.id).tap do |payment|
      payment.assign_attributes(build_payment_attributes(payroll))
    end
  end

  def process_new_payment(payment)
    payment.save
    PayrollReportMailerService.new(@customer, payment).send_email
  end

  # rubocop:disable Metrics/AbcSize
  def build_payment_attributes(payroll)
    {
      customer_id: @customer.id,
      individual_ids: payroll['individual_ids'],
      pay_group_ids: payroll['pay_group_ids'],
      pay_date: payroll['pay_date'],
      debit_date: payroll['debit_date'],
      pay_period_start: payroll.dig('pay_period', 'start_date'),
      pay_period_end: payroll.dig('pay_period', 'end_date'),
      company_debit_amount: payroll.dig('company_debit', 'amount'),
      company_debit_currency: payroll.dig('company_debit', 'currency'),
      gross_pay_amount: payroll.dig('gross_pay', 'amount'),
      gross_pay_currency: payroll.dig('gross_pay', 'currency'),
      net_pay_amount: payroll.dig('net_pay', 'amount'),
      net_pay_currency: payroll.dig('net_pay', 'currency'),
      employer_taxes_amount: payroll.dig('employer_taxes', 'amount'),
      employer_taxes_currency: payroll.dig('employer_taxes', 'currency'),
      employee_taxes_amount: payroll.dig('employee_taxes', 'amount'),
      employee_taxes_currency: payroll.dig('employee_taxes', 'currency'),
      pay_frequencies: payroll['pay_frequencies']
    }
  end
  # rubocop:enable Metrics/AbcSize

  def generate_related_data(payment)
    PayrollStatementService.new(@access_token, payment).fetch_and_store_statements
    PayrollEmployeeService.new(@access_token, payment.individual_ids).fetch_and_store_employees
  end

  def fetch_payroll_data
    Tryfinch::API::Payroll.new(
      customer_token: @access_token,
      start_date: @start_date,
      end_date: @end_date,
      api_version: '2020-09-17'
    ).fetch_payroll
  end
end
