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

require 'test_helper'

class PlaidItemTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
