class PayrollReportService
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
      PayrollReport.find_or_create_by(payroll_id: payroll["id"]) do |report|
        report.customer_id = @customer.id
        report.pay_period_start = payroll.dig("pay_period", "start_date")
        report.pay_period_end = payroll.dig("pay_period", "end_date")
        report.pay_date = payroll["pay_date"]
        report.gross_pay = payroll.dig("gross_pay", "amount")
        report.net_pay = payroll.dig("net_pay", "amount")
        report.currency = payroll.dig("gross_pay", "currency")
        report.individual_ids = payroll["individual_ids"]

        PayrollEmployeeService.new(@access_token, report.payroll_id, report.individual_ids).fetch_and_store_employees
      end
    end
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
