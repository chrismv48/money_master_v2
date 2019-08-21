# == Schema Information
#
# Table name: plaid_items
#
#  id             :string           not null, primary key
#  user_id        :integer          not null
#  institution_id :string           not null
#  access_token   :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class PlaidItem < ApplicationRecord
  belongs_to :user
  has_many :plaid_accounts
  has_many :plaid_transactions, through: :plaid_accounts
end
