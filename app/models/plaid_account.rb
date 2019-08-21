# == Schema Information
#
# Table name: plaid_accounts
#
#  id            :string           not null, primary key
#  plaid_item_id :string           not null
#  name          :string
#  official_name :string
#  account_type  :string
#  subtype       :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class PlaidAccount < ApplicationRecord
  belongs_to :plaid_item
  has_many :plaid_transactions
end
