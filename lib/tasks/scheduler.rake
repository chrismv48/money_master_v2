desc "send dat email"
task send_activity_summary_email: :environment do
  PlaidItem.all.each do |plaid_item|
    PlaidInteractor.persist_accounts_for_item(plaid_item)
    PlaidInteractor.persist_transactions_for_item(plaid_item)
  end

  PlaidInteractor.send_activity_summary_email
end
