class ArchivePayrollsController < ApplicationController
  before_action :set_customer

  def index
    @archive_payrolls = @customer.archive_payrolls.order(created_at: :desc)
  end

  def new
    @archive_payroll = ArchivePayroll.new
  end

  def create
    start_date = params[:start_date]
    end_date = params[:end_date]
    PayrollReportService.new(@customer, start_date, end_date).fetch_and_store_payroll
    PayrollExportService.new(@customer, start_date, end_date).export_csv
    file_name = "payroll_report_#{start_date}_to_#{end_date}.csv"
    archive = @customer.archive_payrolls.create!(
      start_date: start_date,
      end_date: end_date,
      file_path: "/payroll_reports/#{@customer.id}/#{file_name}"
    )
    redirect_to archive_payrolls_path, notice: "Payroll report successfully generated."
  end

  private

  def set_customer
    @customer = current_user.customer
  end
end
