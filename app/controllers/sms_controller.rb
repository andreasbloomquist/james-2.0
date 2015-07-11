class SmsController < ApplicationController
	include Webhookable
  include SmsHelper
  
  after_filter :set_header
 
  skip_before_action :verify_authenticity_token

  def received
    sender = params[:From]
    body = params[:Body]
    
    if new_user?(sender)
      create_user(params)
    else
      send_message sender, body
    end
  end
end
