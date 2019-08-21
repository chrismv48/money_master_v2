class PlaidTransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :amount, :date, :description, :pending, :transaction_type

  belongs_to :plaid_account
end
