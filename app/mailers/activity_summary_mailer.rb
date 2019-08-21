class ActivitySummaryMailer < ApplicationMailer

  def activity_summary_email
    all_transactions = PlaidTransaction.where(pending: false).includes(:plaid_account).all

    @grouped_by_normalized_description = all_transactions.group_by(&:normalized_description)

    # TODO: make this filter since last email was sent somehow
    @new_transactions = all_transactions
                          .where("date >= ?", Time.zone.today - 1.week)
                          .order(date: :desc)

    accounts = []
    PlaidItem.all.find_each do |plaid_item|
      plaid_api = PlaidApi.new(environment: :development, access_token: plaid_item.access_token)
      accounts.concat(plaid_api.get_accounts)
    end

    transactions_grouped_by_account = all_transactions.group_by(&:plaid_account_id)
    @daily_account_balances = {}
    @savings_per_period = {}

    accounts.each do |account|
      plaid_account = PlaidAccount.find(account['account_id'])
      next if plaid_account['account_type'] == 'brokerage'
      account_balances_by_date = {}

      account_transactions = transactions_grouped_by_account[account['account_id']]

      next if account_transactions.blank?

      earliest_transaction_date = account_transactions.min_by {|t| t.date}.date
      account_transactions_grouped_by_date = account_transactions.group_by(&:date)
      current_balance = account["balances"]["current"]

      account_balances_by_date[Time.zone.today] = current_balance

      # going from the earliest transaction date to today, calculate daily balances
      (earliest_transaction_date..Time.zone.today).each do |date|
        transactions_for_date = account_transactions_grouped_by_date[date] || []

        net_change_for_date = transactions_for_date.sum(&:amount)
        new_balance = current_balance - net_change_for_date
        account_balances_by_date[date - 1.day] = new_balance
        current_balance = new_balance
      end

      @daily_account_balances[plaid_account] = account_balances_by_date

      transactions_grouped_by_month = all_transactions.group_by {|transaction| transaction.date.strftime('%Y-%m')}

      cumulative_inflows = 0
      cumulative_net_flow = 0
      transactions_grouped_by_month.keys.sort.each do |period|
        transactions_for_period = transactions_grouped_by_month[period]
        inflows = transactions_for_period.select {|transaction| transaction.amount.negative?}.sum(&:amount).abs
        outflows = transactions_for_period.select {|transaction| transaction.amount.positive?}.sum(&:amount)
        net_flow = inflows - outflows
        period_savings_rate = net_flow / inflows

        cumulative_inflows += inflows
        cumulative_net_flow += net_flow

        cumulative_savings_rate = cumulative_net_flow / cumulative_inflows

        @savings_per_period[period] = {
          inflows: inflows,
          outflows: outflows,
          net_flow: net_flow,
          period_savings_rate: period_savings_rate,
          cumulative_savings_rate: cumulative_savings_rate
        }
      end
    end

    mail(to: Rails.application.credentials.gmail[:username] + '@gmail.com', subject: 'Activity Summary')
  end

end


# {"account_id"=>"pZKd9w7ek1t8x1wvmqpPFj5N3QbVZAFJV8XdD",
#  "balances"=>{"available"=>17117.29, "current"=>6568.1, "iso_currency_code"=>"USD", "limit"=>23800},
#  "mask"=>"3810",
#  "name"=>"Shared Credit Card",
#  "official_name"=>"Chase Sapphire Preferred®",
#  "subtype"=>"credit card",
#  "type"=>"credit"},
#   {"account_id"=>"XevM1YPOzZFv4yLe5Rp3T7vK6kXdANC4pnDVX",
#    "balances"=>{"available"=>6172.92, "current"=>299.79, "iso_currency_code"=>"USD", "limit"=>6500},
