class PayrollCsvSummaryService
  def initialize(statements)
    @statements = statements
  end

  def initialize_totals
    {
      employees: 0, descriptions: [],
      total_hours: 0, total_earnings: Hash.new(0),
      total_reimbursements: Hash.new(0), total_net_pay: 0,
      total_withholdings: Hash.new(0), total_deductions: Hash.new(0)
    }
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def update_totals(totals, statement, _employee)
    totals[:employees] += 1
    totals[:total_hours] += statement.total_hours.to_f
    totals[:total_net_pay] += statement.net_pay_amount.to_f
    totals[:descriptions] += statement.earnings.pluck('name')

    statement.earnings&.each do |earning|
      totals[:total_earnings][earning['name']] += earning['amount'].to_f
    end

    statement.taxes&.each do |tax|
      totals[:total_withholdings][tax['name']] += tax['amount'].to_f unless tax['employer']
    end

    statement.employee_deductions&.each do |ded|
      totals[:total_deductions][ded['name']] += ded['amount'].to_f
    end

    statement.employer_contributions&.each do |reim|
      totals[:total_reimbursements][reim['name']] += reim['amount'].to_f
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity

  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def write_summary(csv, totals)
    formatter = PayrollCsvFormatterService.new

    csv << []
    csv << [
      '',
      "#{totals[:employees]} Person",
      totals[:descriptions].uniq.join(', '),
      '',
      totals[:total_hours],
      formatter.format_grouped_data(totals[:total_earnings]),
      formatter.format_grouped_data(totals[:total_reimbursements]),
      formatter.format_grouped_data(totals[:total_withholdings]),
      formatter.format_grouped_data(totals[:total_deductions]),
      totals[:total_net_pay]
    ]

    csv << [
      '', '', '', '',
      totals[:total_hours],
      grand_total_earnings, '',
      total_employee_liability,
      grand_total_deduction,
      totals[:total_net_pay]
    ]

    csv << ['', '', '', '', '', '', '', 'Employer Liabilities', '']
    csv << ['', '', '', '', '', '', '', tax_grouped_employer, '']
    csv << ['', '', '', '', '', '', '', "TOTAL EMPLOYER LIABILITY: #{total_employer_liability}", '']
    csv << ['', '', '', '', '', '', '', "TOTAL TAXLIABILITY: #{total_taxliability}", '']
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  def grand_total_earnings
    @statements.sum { |statement| statement.earnings&.sum { |e| e['amount'].to_f } || 0 }
  end

  def grand_total_deduction
    @statements.sum { |statement| statement.employee_deductions&.sum { |d| d['amount'].to_f } || 0 }
  end

  def total_employee_liability
    @statements.sum { |statement| statement.taxes&.reject { |t| t['employer'] }&.sum { |t| t['amount'].to_f } || 0 }
  end

  def total_employer_liability
    @statements.sum { |statement| statement.taxes&.select { |t| t['employer'] }&.sum { |t| t['amount'].to_f } || 0 }
  end

  def total_taxliability
    @statements.sum { |statement| statement.taxes&.sum { |t| t['amount'].to_f } || 0 }
  end

  def tax_grouped_employer
    employer_taxes = Hash.new(0)
    @statements.each do |statement|
      statement.taxes&.each do |tax|
        employer_taxes[tax['name']] += tax['amount'].to_f if tax['employer']
      end
    end
    PayrollCsvFormatterService.new.format_grouped_data(employer_taxes)
  end
end
