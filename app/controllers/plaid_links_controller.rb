class PlaidLinksController < ApplicationController
  before_action :set_plaid_link, only: [:show, :edit, :update, :destroy]

  # GET /plaid_links
  # GET /plaid_links.json
  def index

  end


  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def plaid_link_params
    params.fetch(:plaid_link, {})
  end
end
