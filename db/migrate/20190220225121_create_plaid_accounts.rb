class CreatePlaidAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :plaid_accounts, {id: false} do |t|
      t.string :id, primary_key: true
      t.string :plaid_item_id, null: false
      t.string :name
      t.string :official_name
      t.string :account_type
      t.string :subtype

      t.timestamps
    end
  end
end
