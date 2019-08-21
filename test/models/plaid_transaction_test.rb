# == Schema Information
#
# Table name: plaid_transactions
#
#  id                :string           not null, primary key
#  plaid_account_id  :string           not null
#  amount            :float            not null
#  date              :date
#  iso_currency_code :string
#  description       :string
#  pending           :boolean
#  transaction_type  :string
#  category_id       :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'test_helper'

class PlaidTransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
