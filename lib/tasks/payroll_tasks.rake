namespace :payroll do
  desc "Fetch payroll data and store in database"
  task :generate_report, [:start_date, :end_date] => :environment do |_, args|
    start_date = args[:start_date] || Date.today.beginning_of_month.to_s
    end_date = args[:end_date] || Date.today.end_of_month.to_s

    Customer.where.not(access_token: nil).each do |customer|
      PayrollReportService.new(customer, start_date, end_date).fetch_and_store_payroll
    end

    puts "Payroll data successfully stored in the database."
  end

  desc "Export payroll report to CSV"
  task :export_csv, [:start_date, :end_date] => :environment do |_, args|
    start_date = args[:start_date] || Date.today.beginning_of_month.to_s
    end_date = args[:end_date] || Date.today.end_of_month.to_s

    Customer.where.not(access_token: nil).find_each do |customer|
      PayrollExportService.new(customer, start_date, end_date).export_csv
    end

    puts "✅ Payroll reports successfully exported for all customers."
  end
end
