class PayrollMailer < ApplicationMailer
  
  def send_payroll_report
    @customer = params[:customer]
    file_path = params[:file_path]
    pay_date = params[:pay_date]

    attachments["payroll_report_#{pay_date}.csv"] = File.read(file_path)
    
    mail(
      to: @customer.user.email,
      subject: "Payroll Report for #{pay_date}",
      body: "Dear #{@customer.user.fullname},\n\nAttached is your payroll report for #{pay_date}.\n\nBest regards,\nPayroll Team"
    )
  end
end