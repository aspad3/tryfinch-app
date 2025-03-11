class PayrollsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_user!

  def index
    @payrolls = current_user.customer.payroll_payments.order(pay_date: :asc)
  end
end
