class PayrollCsvFormatterService
  def format_earning(statement)
    statement.earnings.pluck('amount').join("\n")
  end

  def format_description(statement, descriptions)
    descriptions.concat(statement.earnings.pluck('name'))
    statement.earnings.pluck('name').join("\n")
  end

  def format_reimbursements(statement)
    statement.employer_contributions.map { |c| "#{c['name']}: #{c['amount']}" }.join("\n")
  end

  def format_withholdings(taxes)
    return '' if taxes.blank?

    taxes.reject { |tax| tax['employer'] }
         .map { |tax| "#{tax['name']}: #{tax['amount']}" }
         .join("\n")
  end

  def format_deductions(deductions)
    return '' if deductions.blank?

    deductions.map { |ded| "#{ded['name']}: #{ded['amount']}" }.join("\n")
  end

  def format_grouped_data(grouped_data)
    return '' if grouped_data.empty?

    grouped_data.map { |name, total| "#{name}: #{total}" }.join("\n")
  end
end
