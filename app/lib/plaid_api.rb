require 'plaid'
require 'active_support/all'

# Item: a set of credentials at a financial institution; each Item can have many Accounts, and some Accounts have Transactions associated with them
# client_id and secret: two private API keys; used in conjunction with an access_token to access data for an Item
# public_key: a public API identifier; used to initialize Link and identify Items you create or update via Link
# access_token: a rotatable token unique to a single Item; used to access data for that Item
# public_token: a short-lived token that can be exchanged for an access_token or used to initialize Link in update mode for an Item

# ITEM
# {
#   "available_products"=>["assets", "auth", "balance", "credit_details", "identity", "income"],
#   "billed_products"=>["transactions"],
#   "institution_id"=>"ins_3",
#   "item_id"=>"ggaN8aVQr3UN3a9zA5wBcvlPKl3lxDFgBArVQ",
#   "webhook"=>"https://requestb.in"
# }

# ACCOUNT
# {
#   "account_id"=>"bMzw1zVNaquQRaP9AK1lTXqKPM16rzCV5WPvN",
#   "balances"=>{"available"=>200, "current"=>210, "iso_currency_code"=>"USD"},
#   "mask"=>"1111",
#   "name"=>"Plaid Saving",
#   "official_name"=>"Plaid Silver Standard 0.1% Interest Saving",
#   "subtype"=>"savings",
#   "type"=>"depository"
# },

# TRANSACTION
# {
#   "account_id"=>"bMzw1zVNaquQRaP9AK1lTXqKPM16rzCV5WPvN",
#   "amount"=>25,
#   "category"=>["Payment", "Credit Card"],
#   "category_id"=>"16001000",
#   "date"=>"2019-02-20",
#   "iso_currency_code"=>"USD",
#   "location"=>{},
#   "name"=>"CREDIT CARD 3333 PAYMENT *//",
#   "payment_meta"=>{},
#   "pending"=>false,
#   "transaction_id"=>"3RXLqXgzWNs1gmxzXk8wHwMag5lgW4hqGoj93",
#   "transaction_type"=>"special"
# }

class PlaidApi

  attr_reader :access_token, :public_token, :environment, :client

  CLIENT_ID = Rails.application.credentials.plaid_api[:client_id]
  SECRET = Rails.application.credentials.plaid_api[:secret]
  PUBLIC_KEY = Rails.application.credentials.plaid_api[:public_key]

  SANDBOX_HOST = "https://sandbox.plaid.com".freeze
  DEVELOPMENT_HOST = "https://development.plaid.com".freeze
  PRODUCTION_HOST = "https://production.plaid.com".freeze

  ENVIRONMENT_HOSTS = {
    sandbox: SANDBOX_HOST,
    development: DEVELOPMENT_HOST,
    production: PRODUCTION_HOST,
  }.freeze

  def initialize(environment: :sandbox, access_token: nil, public_token: nil)
    @client = Plaid::Client.new(env: environment,
                                client_id: CLIENT_ID,
                                secret: SECRET,
                                public_key: PUBLIC_KEY)

    if access_token
      @access_token = access_token
    elsif public_token
      @access_token = get_access_token(public_token)
    else
      raise 'Must provide either an access_token or public_token'
    end
  end

  def get_access_token(public_token)
    response = @client.item.public_token.exchange(public_token)
    @access_token = response.access_token
  end

  def get_transactions(start_date:, end_date: Date.today)
    transaction_response = @client.transactions.get(@access_token, start_date, Date.today)
    transactions = transaction_response.transactions

    # the transactions in the response are paginated, so make multiple calls while
    # increasing the offset to retrieve all transactions
    while transactions.length < transaction_response['total_transactions']
      transaction_response = @client.transactions.get(
        @access_token,
        start_date,
        end_date,
        offset: transactions.length,
        count: 500
      )
      transactions += transaction_response.transactions
    end

    return transactions
  end

  def get_accounts
    accounts_response = @client.accounts.get(@access_token)
    return accounts_response.accounts
  end
end
