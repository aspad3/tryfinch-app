json.extract! customer, :id, :customer_id, :customer_name, :created_at, :updated_at
json.url customer_url(customer, format: :json)
