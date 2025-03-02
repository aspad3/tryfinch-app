require "csv"
require "fileutils"

class PayrollExportService
  def initialize(customer, start_date, end_date)
    @customer = customer
    @start_date = start_date.to_date
    @end_date = end_date.to_date

  end

  def export_csv
    payrolls = PayrollReport.includes(:payroll_employees)
                        .where(pay_period_start: @start_date.beginning_of_day..@end_date.end_of_day)


    return nil if payrolls.blank?

    # Buat folder berdasarkan customer ID di `public/payroll_reports/{customer_id}`
    folder_path = Rails.root.join("public", "payroll_reports", @customer.id.to_s)
    FileUtils.mkdir_p(folder_path)

    # Tentukan path file CSV
    file_path = folder_path.join("payroll_report_#{@start_date}_to_#{@end_date}.csv")

    # Generate CSV
    CSV.open(file_path, "w", write_headers: true, headers: csv_headers) do |csv|
      payrolls.each do |report|
        report.payroll_employees.each do |employee|
          csv << csv_row(report, employee)
        end
      end
    end

    puts "Payroll report exported to: #{file_path}"
  end

  private

  def csv_headers
    [
      "Payroll ID", "Start Date", "End Date", "Pay Date", "Gross Pay", "Net Pay", "Currency",
      "Employee ID", "First Name", "Middle Name", "Last Name", "Title", "Employment Type",
      "Employment Subtype", "Start Date", "End Date", "Latest Rehire Date", "Active",
      "Location", "Income Amount", "Income Currency", "Income Unit", "Email"
    ]
  end

  def csv_row(report, employee)
    [
      report.payroll_id,
      report.pay_period_start,
      report.pay_period_end,
      report.pay_date,
      report.gross_pay,
      report.net_pay,
      report.currency,
      employee.employee_id,
      employee.first_name,
      employee.middle_name.presence || "-",
      employee.last_name,
      employee.title.presence || "-",
      employee.employment_type.presence || "-",
      employee.employment_subtype.presence || "-",
      employee.start_date,
      employee.end_date.presence || "-",
      employee.latest_rehire_date.presence || "-",
      employee.is_active ? "Yes" : "No",
      employee.location.presence || "-",
      employee.income_amount.presence || 0,
      employee.income_currency.presence || "-",
      employee.income_unit.presence || "-",
      employee.email.presence || "-"
    ]
  end
end
