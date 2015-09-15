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
    
    if easter?(@body)
      return send_easter_egg(sender)
      
    elsif new_user?(sender)
      create_user(params)

    elsif stop_response? @body
      User.find_by_phone_number(sender).update_to_inactive
      render nothing: true

    elsif start_response? @body
      User.find_by_phone_number(sender).update_to_active
      render nothing: true

    elsif property_respose? @body
      send_property_response(@body, sender)

    elsif fresh_start?(@body)
      start_fresh_lead(sender)

    elsif responding_to_appointment?(sender, @body) && lead_complete?(sender)
      appt_confirmation(sender, @body)
      
    else
      send_user_questions sender, @body
    end
  end

  private

  def stop_response?(body)
    sanitized = body.downcase
    return true if sanitized === 'stop' || sanitized === 'unsubscribe' || sanitized === 'cancel' || sanitized === 'end' || sanitized === 'quit'
  end

  def start_response?(body)
    sanitized = body.downcase
    return true if sanitized === 'start' || sanitized === 'yes'
  end
end
