json.extract! plaid_link, :id, :created_at, :updated_at
json.url plaid_link_url(plaid_link, format: :json)
