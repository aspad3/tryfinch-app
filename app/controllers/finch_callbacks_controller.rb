class FinchCallbacksController < ApplicationController
  protect_from_forgery except: :handle

  def handle
    code = params[:code]
    return render json: { error: "No authorization code received" }, status: :unprocessable_entity unless code

    # Exchange the authorization code for the access token
    # result = FinchTokenService.exchange_code_for_token(code)
    result = Tryfinch::API::Token.exchange_code_for_token(code)

    if result && result["access_token"]
      # Find the customer by the customer_id (assumed that customer_id is in the result)
      customer = User.find_by(id: result["customer_id"])&.customer

      if customer
        # Update the customer with the access token and response from Finch
        customer.update!(
          access_token: result["access_token"],
          response_finch: result
        )
        Rails.logger.info("Successfully updated customer with access token: #{result['access_token']}")
        
        # Redirect to customers path with a success message
        redirect_to root_path, notice: "Customer successfully updated with access token."
      else
        flash[:alert] = "Customer not found for given customer_id"
        redirect_to root_path
      end
    else
      flash[:alert] = "Failed to exchange authorization code"
      redirect_to root_path
    end
  end
end