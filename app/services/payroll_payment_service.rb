class PayrollPaymentService
  def initialize(customer, start_date, end_date)
    @customer = customer
    @access_token = customer.access_token
    @start_date = start_date
    @end_date = end_date
  end

  def fetch_and_store_payroll
    payroll_data = fetch_payroll_data

    payroll_data.each do |payroll|
      next if payroll.blank?
      PayrollPayment.find_or_create_by(payroll_id: payroll["id"], customer_id: @customer.id) do |payment|
        payment.customer_id = @customer.id
        payment.individual_ids = payroll["individual_ids"]
        payment.pay_group_ids = payroll["pay_group_ids"]
        payment.pay_date = payroll["pay_date"]
        payment.debit_date = payroll["debit_date"]
        payment.pay_period_start = payroll.dig("pay_period", "start_date")
        payment.pay_period_end = payroll.dig("pay_period", "end_date")
        payment.company_debit_amount = payroll.dig("company_debit", "amount")
        payment.company_debit_currency = payroll.dig("company_debit", "currency")
        payment.gross_pay_amount = payroll.dig("gross_pay", "amount")
        payment.gross_pay_currency = payroll.dig("gross_pay", "currency")
        payment.net_pay_amount = payroll.dig("net_pay", "amount")
        payment.net_pay_currency = payroll.dig("net_pay", "currency")
        payment.employer_taxes_amount = payroll.dig("employer_taxes", "amount")
        payment.employer_taxes_currency = payroll.dig("employer_taxes", "currency")
        payment.employee_taxes_amount = payroll.dig("employee_taxes", "amount")
        payment.employee_taxes_currency = payroll.dig("employee_taxes", "currency")
        payment.pay_frequencies = payroll["pay_frequencies"]
        payment.save

        generata_payment_statement(payment)
        generate_employee(payment)
      end
    end
  end

  def generata_payment_statement(payment)
    PayrollStatementService.new(@access_token, payment).fetch_and_store_statements
  end

  def generate_employee(payment)
    PayrollEmployeeService.new(@access_token, payment.individual_ids).fetch_and_store_employees
  end

  private

  def fetch_payroll_data
    payroll_api = Tryfinch::API::Payroll.new(
      customer_token: @access_token,
      start_date: @start_date,
      end_date: @end_date,
      api_version: "2020-09-17"
    )
    payroll_api.fetch_payroll
  end
end
