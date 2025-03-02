class PayrollEmployeeService
  def initialize(access_token, payroll_id, individual_ids)
    @access_token = access_token
    @payroll_id = payroll_id
    @individual_ids = individual_ids
  end

  def fetch_and_store_employees
    employees_data = fetch_employee_data

    return if employees_data.blank? || employees_data["responses"].blank?

    employees_data["responses"].each do |employee_response|
      next unless employee_response["code"] == 200 && employee_response["body"].present?

      employee = employee_response["body"]
      
      payroll_employee = PayrollEmployee.find_or_initialize_by(payroll_id: @payroll_id, employee_id: employee["id"])
      payroll_employee.assign_attributes(
        first_name: employee["first_name"],
        last_name: employee["last_name"],
        middle_name: employee["middle_name"],
        title: employee["title"],
        employment_type: employee.dig("employment", "type"),
        employment_subtype: employee.dig("employment", "subtype"),
        start_date: employee["start_date"],
        end_date: employee["end_date"],
        latest_rehire_date: employee["latest_rehire_date"],
        is_active: employee["is_active"],
        location: format_location(employee["location"]),
        income_amount: employee.dig("income", "amount"),
        income_currency: employee.dig("income", "currency"),
        income_unit: employee.dig("income", "unit")
      )
      payroll_employee.save if payroll_employee.changed?
    end
  end

  private

  def fetch_employee_data
    employee_api = Tryfinch::API::Employees.new(customer_token: @access_token, individual_ids: @individual_ids)
    response = employee_api.fetch_employment

    log_api_error(response) unless response.is_a?(Hash) && response["responses"]
    response
  end

  def format_location(location)
    return nil unless location

    "#{location["line1"]}, #{location["line2"]}, #{location["city"]}, #{location["state"]}, #{location["country"]}, #{location["postal_code"]}".strip
  end

  def log_api_error(response)
    Rails.logger.error("Failed to fetch employees: #{response.inspect}")
  end
end
