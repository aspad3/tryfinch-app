class CustomersController < ApplicationController
  before_action :set_customer, only: :connect

  def index; end

  def connect
    if (session_url = Tryfinch::API::SessionConnect.create_url(@customer.id, @customer.customer_name))
      redirect_to session_url, allow_other_host: true, notice: 'Session successfully created.'
    else
      redirect_to root_path, alert: 'Failed to generate session token.'
    end
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, alert: 'Customer not found.'
  end
end
