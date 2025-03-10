require 'csv'
require 'fileutils'
require_relative 'payroll_csv_formatter_service'
require_relative 'payroll_csv_summary_service'

class PayrollCsvGeneratorService
  def initialize(payroll_payment)
    @payroll_payment = payroll_payment
    @statements = PayrollPaymentStatement.where(payment_id: payroll_payment.payroll_id)
    @formatter = PayrollCsvFormatterService.new
    @summary = PayrollCsvSummaryService.new(@statements)
  end

  def generate_csv_file
    file_path = prepare_file_path

    CSV.open(file_path, 'w') do |csv|
      write_headers(csv)

      totals = @summary.initialize_totals

      @statements.each do |statement|
        employee = PayrollEmployee.find_by(individual_id: statement.individual_id)
        next unless employee

        @summary.update_totals(totals, statement, employee)
        csv << generate_employee_row(statement, employee, totals[:descriptions])
      end

      @summary.write_summary(csv, totals)
    end

    file_path
  end

  private

  def prepare_file_path
    customer_id = @payroll_payment.customer_id
    pay_date = @payroll_payment.pay_date.strftime('%Y-%m-%d')
    directory_path = "public/payroll_reports/#{customer_id}"
    FileUtils.mkdir_p(directory_path) unless File.directory?(directory_path)
    "#{directory_path}/#{pay_date}.csv"
  end

  def write_headers(csv)
    csv << ["Employee ID", "Employee Name", "Description", "Rate", "Hours", "Earnings", "Reimbursements & Other Payments", "Withholdings", "Deductions", "Net Pay"]
  end

  def generate_employee_row(statement, employee, descriptions)
    [
      employee.individual_id,
      "#{employee.first_name} #{employee.last_name}",
      @formatter.format_description(statement, descriptions),
      employee.income["amount"],
      statement.total_hours,
      @formatter.format_earning(statement),
      @formatter.format_reimbursements(statement),
      @formatter.format_withholdings(statement.taxes),
      @formatter.format_deductions(statement.employee_deductions),
      statement.net_pay_amount
    ]
  end
end
