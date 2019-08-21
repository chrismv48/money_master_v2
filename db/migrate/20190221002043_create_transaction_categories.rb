class CreateTransactionCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :transaction_categories do |t|
      t.belongs_to :transaction
      t.string :category

      t.timestamps
    end
  end
end
