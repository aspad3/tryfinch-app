class PayrollMailer < ApplicationMailer
  def send_payroll_report
    @customer = params[:customer]
    file_path = params[:file_path]
    pay_date = params[:pay_date]

    attachments["#{pay_date}.csv"] = File.read(file_path)

    recipient = @customer.user.email
    subject_line = "Payroll Report for #{pay_date}"
    body_content = <<~BODY
      Dear #{@customer.user.fullname},

      Attached is your payroll report for #{pay_date}.

      Best regards,
      Payroll Team
    BODY

    mail(to: recipient, subject: subject_line, body: body_content)
  end
end
