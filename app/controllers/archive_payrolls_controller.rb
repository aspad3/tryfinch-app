class ArchivePayrollsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_customer
  before_action :set_archive, only: %i[show]
  before_action :set_payroll, only: %i[download send_email]

  # rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    @archive_payrolls = @customer.archive_payrolls.order(created_at: :desc)
  end

  def new
    @archive_payroll = ArchivePayroll.new
  end

  def create
    archive = @customer.archive_payrolls.new(
      start_date: params[:start_date],
      end_date: params[:end_date]
    )

    if archive.save
      PayrollPaymentService.new(@customer, archive.start_date, archive.end_date).fetch_and_store_payroll

      @customer.payroll_payments.where(pay_date: archive.start_date..archive.end_date).each do |payment|
        PayrollCsvGeneratorService.new(payment).generate_csv_file
      end

      redirect_to archive_payrolls_path, notice: "✅ Payroll report successfully created."
    else
      flash[:alert] = archive.errors.full_messages.to_sentence
      redirect_to new_archive_payroll_path
    end
  end

  def show
    @payrolls = PayrollPayment.where(pay_date: @archive.start_date..@archive.end_date).order(pay_date: :asc)
  end

  def download
    if File.exist?(PayrollCsvGeneratorService.new(@payroll).generate_csv_file)
      send_file payroll_report_path, filename: File.basename(payroll_report_path), type: "text/csv"
    else
      redirect_to request.referer || payrolls_path , alert: "❌ File not found."
    end
  end

  def send_email
    PayrollReportMailerService.new(@customer, @payroll).send_email
    redirect_to request.referer || payrolls_path, notice: "📧 Payroll report email sent."
  end

  private

  def set_customer
    @customer = current_user.customer
  end

  def set_archive
    @archive = @customer.archive_payrolls.find(params[:id])
  end

  def set_payroll
    @payroll = PayrollPayment.find(params[:payroll_payment_id])
  end

  def payroll_report_path
    Rails.root.join("public", "payroll_reports", @customer.id.to_s, "#{@payroll.pay_date}.csv")
  end

  def create_archive
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    archive = @customer.archive_payrolls.create!(
      start_date: start_date,
      end_date: end_date
    )

    [archive, start_date, end_date]
  end

  def record_not_found
    redirect_to archive_payrolls_path, alert: "⚠️ Record not found."
  end
end
