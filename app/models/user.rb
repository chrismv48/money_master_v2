# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  username   :string           not null
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :plaid_items
  has_many :plaid_accounts, through: :plaid_items
end
