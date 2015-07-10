class SmsController < ApplicationController
	include Webhookable
  include SmsHelper

  after_filter :set_header
 
  skip_before_action :verify_authenticity_token

  def index

  end

  def received
    sender = params[:From]
    create_user(params) if new_user?(sender)
  end
end
