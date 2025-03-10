require 'csv'
require 'fileutils'

class PayrollCsvService
  def initialize(payroll_payment)
    @payroll_payment = payroll_payment
    @statements = PayrollPaymentStatement.where(payment_id: payroll_payment.payroll_id)
  end

  def generate_csv_file
    file_path = prepare_file_path

    CSV.open(file_path, 'w') do |csv|
      write_headers(csv)
      totals = initialize_totals

      @statements.each do |statement|
        employee = PayrollEmployee.find_by(individual_id: statement.individual_id)
        next unless employee

        update_totals(totals, statement, employee)
        csv << generate_employee_row(statement, employee, totals[:descriptions])
      end

      write_summary(csv, totals)
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

  def initialize_totals
    {
      employees: 0,
      descriptions: [],
      total_hours: 0,
      total_earnings: Hash.new(0),
      total_reimbursements: Hash.new(0),
      total_net_pay: 0,
      total_withholdings: Hash.new(0),
      total_deductions: Hash.new(0)
    }
  end

  def update_totals(totals, statement, employee)
    totals[:employees] += 1
    totals[:total_hours] += statement.total_hours.to_f
    totals[:total_net_pay] += statement.net_pay_amount.to_f
    totals[:descriptions] += statement.earnings.map { |e| e["name"] }

    statement.earnings&.each do |earning|
      totals[:total_earnings][earning["name"]] += earning["amount"].to_f
    end

    statement.taxes&.each do |tax|
      totals[:total_withholdings][tax["name"]] += tax["amount"].to_f unless tax["employer"]
    end

    statement.employee_deductions&.each do |ded|
      totals[:total_deductions][ded["name"]] += ded["amount"].to_f
    end

    statement.employer_contributions&.each do |reim|
      totals[:total_reimbursements][reim["name"]] += reim["amount"].to_f
    end
  end

  def generate_employee_row(statement, employee, descriptions)
    [
      employee.individual_id,
      "#{employee.first_name} #{employee.last_name}",
      format_description(statement, descriptions),
      employee.income["amount"],
      statement.total_hours,
      format_earning(statement),
      format_reimbursements(statement),
      format_withholdings(statement.taxes),
      format_deductions(statement.employee_deductions),
      statement.net_pay_amount
    ]
  end

  def write_summary(csv, totals)
    csv << []
    csv << [
      "",
      "#{totals[:employees]} Person",
      totals[:descriptions].uniq.join(', '),
      "",
      totals[:total_hours],
      format_grouped_data(totals[:total_earnings]),  
      format_grouped_data(totals[:total_reimbursements]),  # Reimbursements sekarang dihitung!
      format_grouped_data(totals[:total_withholdings]),
      format_grouped_data(totals[:total_deductions]),
      totals[:total_net_pay]
    ]

    csv << [
      "",
      "",
      "",
      "",
      totals[:total_hours],
      grand_total_earnings,  
      "",
      total_employee_liability,
      grand_total_deduction,
      totals[:total_net_pay]
    ]

    csv << ['','','','','','','','Employer Liabilities','']
    csv << ['','','','','','','', tax_grouped_employer,'']
    csv << ['','','','','','','', "TOTAL EMPLOYER LIABILITY: #{total_employer_liability}",'']
    csv << ['','','','','','','', "TOTAL TAXLIABILITY: #{total_taxliability}",'']
  end

  def grand_total_earnings
    @statements.sum do |statement|
      statement.earnings&.sum { |earning| earning["amount"].to_f } || 0
    end
  end

  def grand_total_deduction
    @statements.sum do |statement|
      statement.employee_deductions&.sum { |ded| ded["amount"].to_f } || 0
    end
  end

  def total_employee_liability
    @statements.sum do |statement|
      statement.taxes&.select { |tax| tax["employer"] == false }&.sum { |tax| tax["amount"].to_f } || 0
    end
  end

  def total_employer_liability
    @statements.sum do |statement|
      statement.taxes&.select { |tax| tax["employer"] }&.sum { |tax| tax["amount"].to_f } || 0
    end
  end

  def total_taxliability
    @statements.sum do |statement|
      statement.taxes&.sum { |tax| tax["amount"].to_f } || 0
    end
  end

  def tax_grouped_employer
    employer_taxes = Hash.new(0)

    @statements.each do |statement|
      statement.taxes&.each do |tax|
        if tax["employer"]
          employer_taxes[tax["name"]] += tax["amount"].to_f
        end
      end
    end

    format_grouped_data(employer_taxes)
  end

  def format_earning(statement)
    statement.earnings.map { |e| e["amount"] }.join("\n")
  end

  def format_description(statement, descriptions)
    descriptions.concat(statement.earnings.map { |e| e["name"] })
    statement.earnings.map { |e| e["name"] }.join("\n")
  end

  def format_reimbursements(statement)
    statement.employer_contributions.map { |c| "#{c['name']}: #{c['amount']}" }.join("\n")
  end

  def format_withholdings(taxes)
    return "" if taxes.nil? || taxes.empty?

    taxes.reject { |tax| tax["employer"] }
         .map { |tax| "#{tax['name']}: #{tax['amount']}" }
         .join("\n")
  end

  def format_deductions(deductions)
    return "" if deductions.nil? || deductions.empty?

    deductions.map { |ded| "#{ded['name']}: #{ded['amount']}" }.join("\n")
  end

  def format_grouped_data(grouped_data)
    return "" if grouped_data.empty?

    grouped_data.map { |name, total| "#{name}: #{total}" }.join("\n")
  end
end