class PayrollEmployeeService
  def initialize(access_token, individual_ids)
    @access_token = access_token
    @individual_ids = individual_ids
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/MethodLength
  def fetch_and_store_employees
    employees_data = fetch_employee_data

    return if employees_data.blank? || employees_data['responses'].blank?

    employees_data['responses'].each do |employee_response|
      next unless employee_response['code'] == 200 && employee_response['body'].present?

      employee = employee_response['body']
      payroll_employee = PayrollEmployee.find_or_initialize_by(individual_id: employee['id'])
      payroll_employee.first_name = employee['first_name']
      payroll_employee.middle_name = employee['middle_name']
      payroll_employee.last_name = employee['last_name']
      payroll_employee.title = employee['title']
      payroll_employee.manager_id = employee.dig('manager', 'id')
      payroll_employee.department_name = employee.dig('department', 'name')
      payroll_employee.employment_type = employee.dig('employment', 'type')
      payroll_employee.employment_subtype = employee.dig('employment', 'subtype')
      payroll_employee.start_date = employee['start_date']
      payroll_employee.end_date = employee['end_date']
      payroll_employee.latest_rehire_date = employee['latest_rehire_date']
      payroll_employee.is_active = employee['is_active']
      payroll_employee.employment_status = employee['employment_status']
      payroll_employee.class_code = employee['class_code']
      payroll_employee.location = employee['location']
      payroll_employee.income = employee['income']
      payroll_employee.income_history = employee['income_history']
      payroll_employee.custom_fields = employee['custom_fields']
      payroll_employee.save!
      payroll_employee.save if payroll_employee.changed?
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength

  private

  def fetch_employee_data
    employee_api = Tryfinch::API::Employees.new(customer_token: @access_token, individual_ids: @individual_ids)
    response = employee_api.fetch_employment

    log_api_error(response) unless response.is_a?(Hash) && response['responses']
    response
  end

  def format_location(location)
    return nil unless location

    "#{location['line1']}, " \
    "#{location['line2']}, " \
    "#{location['city']}, " \
    "#{location['state']}, " \
    "#{location['country']}, " \
    "#{location['postal_code']}".strip
  end

  def log_api_error(response)
    Rails.logger.error("Failed to fetch employees: #{response.inspect}")
  end
end
