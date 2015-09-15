class SmsController < ApplicationController
	include Webhookable
  include SmsHelper
  include AppointmentsHelper
  include LeadsHelper
  
  after_filter :set_header
 
  skip_before_action :verify_authenticity_token

  def received
    create_log(params)
    sender = params[:From]
    @body = params[:Body]
          
    if new_user?(sender)
      User.create_user(params)
      render nothing: true

    elsif stop_response? @body
      User.find_by_phone_number(sender).update_to_inactive
      render nothing: true

    elsif start_response? @body
      User.find_by_phone_number(sender).update_to_active
      render nothing: true

    elsif property_respose? @body
      send_property_response(@body, sender)

    elsif start_over?(@body)
      User.find_by_phone_number(sender).new_lead
      render nothing: true

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

  def new_user?(number)
    return true if User.find_by_phone_number(number) == nil
  end

  def property_respose?(body)
    sanitized_body = body.downcase
    return true unless Property.find_by_response_code(sanitized_body) == nil
  end

  def start_over?(body)
    sanitized = body.downcase
    return true if sanitized === "start over"
    return false
  end
end
