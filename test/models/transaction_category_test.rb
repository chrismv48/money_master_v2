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

require 'test_helper'

class TransactionCategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
