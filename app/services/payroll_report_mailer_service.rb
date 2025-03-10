class PayrollReportMailerService
  def initialize(customer, payroll)
    @customer = customer
    @payroll = payroll
    @pay_date = @payroll.pay_date.to_date
    @file_path = Rails.root.join("public", "payroll_reports", @customer.id.to_s, "#{@pay_date}.csv")
  end

  def send_email
    return unless File.exist?(PayrollCsvGeneratorService.new(@payroll).generate_csv_file) && @customer.user&.email.present?

    PayrollMailer.with(customer: @customer, file_path: @file_path, pay_date: @pay_date)
                 .send_payroll_report
                 .deliver_now
  end
end
