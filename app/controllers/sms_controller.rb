class SmsController < ApplicationController
	include Webhookable
  include SmsHelper
  include AppointmentsHelper
  include LeadsHelper
  
  after_filter :set_header
 
  skip_before_action :verify_authenticity_token

  def received
    sender = params[:From]
    @body = params[:Body]
    
    if new_user?(sender)
      create_user(params)

    elsif property_respose? @body
      send_property_response(@body)

    elsif responding_to_appointment?(sender, @body) && lead_complete?(sender)
      p "I'm responding to a time to see a property!!!!!!!!!!!"
      # create_sms_msg(sender, "Got it bro, you're replying to a property. This feature is still in development tho...")
      appt_confirmation(sender, @body)
      render nothing: true
    else
      send_user_questions sender, @body
    end
  end
end
