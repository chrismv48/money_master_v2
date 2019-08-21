class PlaidInteractor

  def self.persist_accounts_for_item(item)
    plaid_api = PlaidApi.new(environment: :development, access_token: item.access_token)
    accounts = plaid_api.get_accounts
    accounts.each do |account|
      self.persist_plaid_account_for_item(account, item)
    end
  end

  def self.persist_plaid_account_for_item(account, item)
    plaid_account = PlaidAccount.find_by(id: account.account_id) || PlaidAccount.new
    plaid_account.plaid_item_id = item.id
    plaid_account.id = account.account_id
    plaid_account.name = account.name
    plaid_account.official_name = account.official_name
    plaid_account.subtype = account.subtype
    plaid_account.account_type = account.type
    plaid_account.save!
  end

  def self.persist_transactions_for_item(item, start_date: nil, end_date: Time.zone.today)
    plaid_api = PlaidApi.new(environment: :development, access_token: item.access_token)

    if start_date.nil?
      start_date = item.plaid_transactions.maximum(:created_at)&.to_date || Time.zone.today - 1.year
    end

    item_accounts = item.plaid_accounts
    transactions = plaid_api.get_transactions(start_date: start_date, end_date: end_date)

    transactions.each do |transaction|
      unless transaction.account_id.in?(item_accounts.pluck(:id))
        self.persist_accounts_for_item(item)
      end

      self.persist_transaction(transaction)
    end
  end

  def self.persist_transaction(transaction)
    plaid_transaction = PlaidTransaction.find_by(id: transaction.transaction_id) || PlaidTransaction.new
    plaid_transaction.id = transaction.transaction_id
    plaid_transaction.plaid_account_id = transaction.account_id
    plaid_transaction.amount = transaction.amount
    plaid_transaction.date = Date.parse(transaction.date)
    plaid_transaction.iso_currency_code = transaction.iso_currency_code
    plaid_transaction.description = transaction.name
    plaid_transaction.pending = transaction.pending
    plaid_transaction.transaction_type = transaction.transaction_type
    plaid_transaction.category_id = transaction.category_id

    plaid_transaction.save!
  end

  def self.send_activity_summary_email
    ActivitySummaryMailer.activity_summary_email.deliver_now!
  end
end

