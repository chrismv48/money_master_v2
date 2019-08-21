# == Schema Information
#
# Table name: transaction_categories
#
#  id             :integer          not null, primary key
#  transaction_id :integer
#  category       :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TransactionCategory < ApplicationRecord
  belongs_to :plaid_transaction
end
