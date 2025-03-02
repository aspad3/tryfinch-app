customer_id = Time.now.to_i.to_s
customer_name = "Customer_#{customer_id}"
session_token = AccessTokenService.fetch_token(customer_id, customer_name)