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
    elsif property_respose? body
      p "User responding to property!!!!!!"
      return render nothing: true
    else
      send_message sender, body
    end
  end
end
