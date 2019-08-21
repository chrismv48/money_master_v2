class CreatePlaidItems < ActiveRecord::Migration[5.0]
  def change
    create_table :plaid_items, {id: false} do |t|
      t.string :id, primary_key: true
      t.belongs_to :user, null: false
      t.string :institution_id, null: false
      t.string :access_token, null: false

      t.timestamps
    end
  end
end
