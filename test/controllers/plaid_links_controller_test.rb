require 'test_helper'

class PlaidLinksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plaid_link = plaid_links(:one)
  end

  test "should get index" do
    get plaid_links_url
    assert_response :success
  end

  test "should get new" do
    get new_plaid_link_url
    assert_response :success
  end

  test "should create plaid_link" do
    assert_difference('PlaidLink.count') do
      post plaid_links_url, params: { plaid_link: {  } }
    end

    assert_redirected_to plaid_link_url(PlaidLink.last)
  end

  test "should show plaid_link" do
    get plaid_link_url(@plaid_link)
    assert_response :success
  end

  test "should get edit" do
    get edit_plaid_link_url(@plaid_link)
    assert_response :success
  end

  test "should update plaid_link" do
    patch plaid_link_url(@plaid_link), params: { plaid_link: {  } }
    assert_redirected_to plaid_link_url(@plaid_link)
  end

  test "should destroy plaid_link" do
    assert_difference('PlaidLink.count', -1) do
      delete plaid_link_url(@plaid_link)
    end

    assert_redirected_to plaid_links_url
  end
end
