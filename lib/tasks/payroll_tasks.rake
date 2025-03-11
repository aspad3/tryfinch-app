namespace :payroll do
  desc 'Fetch payroll data and store in database'
  task :generate_report, %i[start_date end_date] => :environment do |_, args|
    start_date = args[:start_date].presence || Time.zone.today.beginning_of_month.to_s
    end_date = args[:end_date].presence || Time.zone.today.to_s

    puts "🔹 Generating payroll report from #{start_date} to #{end_date}..."

    Customer.includes(:payroll_payments).find_each do |customer|
      next unless customer.access_token.present? && customer.token_valid?

      PayrollPaymentService.new(customer, start_date, end_date).fetch_and_store_payroll
    end
  end
end

# Run with default date (today)
# rake payroll:generate_report

# Run with specific dates
# rake payroll:generate_report[2024-01-20,2024-01-20]
