namespace :payroll do
  desc "Fetch payroll data and store in database"
  task :generate_report, [:start_date, :end_date] => :environment do |_, args|
    start_date = args[:start_date].presence || Date.today.beginning_of_month.to_s
    end_date = args[:end_date].presence || Date.today.to_s

    puts "🔹 Generating payroll report from #{start_date} to #{end_date}..."

    Customer.includes(:payroll_payments).find_each do |customer|
      next unless customer.access_token.present? && customer.token_valid?

      payroll =  PayrollPaymentService.new(customer, start_date, end_date).fetch_and_store_payroll
      puts "🔹 There no report for #{start_date} to #{end_date}" if payroll.blank?
      customer.payroll_payments.where(pay_date: Date.parse(start_date)..Date.parse(end_date)).each do |payment|
        PayrollCsvGeneratorService.new(payment).generate_csv_file
        PayrollReportMailerService.new(customer, payment.pay_date).send_email
        puts "🔹 generate CSV for #{customer.customer_name} and payment: #{payment.pay_date}"
      end
    end
  end
end

# Run with default date (today)
# rake payroll:generate_report

# Run with specific dates
# rake payroll:generate_report[2024-01-20,2024-01-20]

