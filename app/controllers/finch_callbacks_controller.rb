class FinchCallbacksController < ApplicationController
  before_action :authenticate_user!
  protect_from_forgery except: :handle

  def disconnect
    customer = Customer.find_by(id: params[:customer_id])

    if customer
      customer.disconnect
      flash[:notice] = 'Successfully disconnected'
    else
      flash[:alert] = 'Customer not found.'
    end

    redirect_to root_path
  end

  # rubocop:disable Metrics/AbcSize
  def handle
    code = params[:code]
    return render json: { error: 'No authorization code received' }, status: :unprocessable_entity unless code

    result = Tryfinch::API::Token.exchange_code_for_token(code)

    if result && result['access_token']
      customer = Customer.find_by(id: result['customer_id'])

      if customer
        # Update the customer with the access token and response from Finch
        customer.update!(access_token: result['access_token'], meta_data: result)

        # Redirect to customers path with a success message
        redirect_to root_path, notice: 'Customer successfully updated with access token.'
      else
        flash[:alert] = 'Customer not found for given customer_id'
        redirect_to root_path
      end
    else
      flash[:alert] = 'Failed to exchange authorization code'
      redirect_to root_path
    end
  end
  # rubocop:enable Metrics/AbcSize
end
