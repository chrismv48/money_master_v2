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

class PlaidTransaction < ApplicationRecord
  belongs_to :plaid_account
  has_many :transaction_categories

  RULES = [
    [/(^Uber.*)/i, 'Uber'],
    [/(^Delta Air.*)/i, 'Delta Air'],
    [/(^Dropbox.*)/i, 'Dropbox'],
    [/(.*To Weichert.*)/i, 'Mortgage Payment to Weichert'],
    [/(.*Hulu.*)/i, 'Hulu'],
    [/(^Seamless.*)/i, 'Seamless'],
    [/(^PEAPOD.*)/i, 'Peapod'],
    [/(^NYCTAXI.*)/i, 'Taxi'],
    [/(^TAXI.*)/i, 'Taxi'],
    [/(^USPS.*)/i, 'USPS'],
    [/^TST\* (.*)/i, '\1'],
    [/(^Vanguard.*)/i, 'Vanguard'],
    [/(^YouTube Prem.*)/i, 'YouTube Premium'],
    [/(^UNITED \d+$)/i, 'United Airlines'],
  ]

  def normalized_description
    normalized_description = self.description

    RULES.each do |rule|
      normalized_description = self.description.sub(rule[0], rule[1])
      if normalized_description != self.description
        break normalized_description
      end
    end

    return normalized_description
  end

  def amount_formatted
    ActionController::Base.helpers.number_to_currency(self.amount)
  end
end
