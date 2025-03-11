class PayrollReportMailerService
  def initialize(customer, payroll)
    @customer = customer
    @payroll = payroll
    @pay_date = @payroll.pay_date.to_date
    @file_path = Rails.public_path.join('payroll_reports', @customer.id.to_s, "#{@pay_date}.csv")
  end

  def send_email
    unless File.exist?(PayrollCsvGeneratorService.new(@payroll).generate_csv_file) && @customer.user&.email.present?
      return
    end

    PayrollMailer.with(customer: @customer, file_path: @file_path, pay_date: @pay_date)
                 .send_payroll_report
                 .deliver_now
  end
end
