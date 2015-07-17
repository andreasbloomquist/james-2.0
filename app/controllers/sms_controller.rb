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

    elsif fresh_start?(@body)
      start_fresh_lead(sender)

    elsif responding_to_appointment?(sender, @body) && lead_complete?(sender)
      appt_confirmation(sender, @body)
      render nothing: true
    else
      send_user_questions sender, @body
    end
  end
end
