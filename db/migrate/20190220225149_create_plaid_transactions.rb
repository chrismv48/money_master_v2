class CreatePlaidTransactions < ActiveRecord::Migration[5.0]
  def change
    create_table :plaid_transactions, {id: false} do |t|
      t.string :id, primary_key: true
      t.string :plaid_account_id, null: false
      t.float :amount, null: false
      t.date :date
      t.string :iso_currency_code
      t.string :description
      t.boolean :pending
      t.string :transaction_type
      t.string :category_id

      t.timestamps
    end
  end
end
