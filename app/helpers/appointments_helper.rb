module AppointmentsHelper
  include SmsHelper

  def responding_to_appointment?(number, body)
    user = User.find_by_phone_number(number)
    appt_option = body.split[0] 
    response_code = body.split[1]
    property = Property.find_by_response_code(response_code)

    if appt_option == "1" || appt_option == "2" || appt_option == "3" && property != nil && property.lead.user == user
      return true
    else
      return false
    end
  end

  # Helper to determine the time that the user is selecting
  def appointment_time(appt)
    case appt.user_response
    when "1"
      return appt.option_one
    when "2"
      return appt.option_two
    else
      return appt.option_three
    end
  end

  def send_appointment_confirmation(number)
    user = User.find_by_phone_number(number)
  end

  def send_available_times(appointment)
    user = appointment.property.lead.user
    available_times_msg = "Hey #{user.name}, I just heard back from the broker. Here are three times they're available to meet: #{appointment.option_one.strftime('%m/%d/%y %l:%M%P')}, reply w/ '1 #{appointment.property.response_code}' for this time. #{appointment.option_two.strftime('%m/%d/%y %l:%M%P')}, reply '2 #{appointment.property.response_code}' for this time. #{appointment.option_three.strftime('%m/%d/%y %l:%M%P')}, reply '3 #{appointment.property.response_code}' for this time."
    create_sms_msg(user.phone_number, available_times_msg)
  end

  def appt_confirmation(number, body)
    user = User.find_by_phone_number(number)
    appt_option = body.split[0]
    response_code = body.split[1]
    property = Property.find_by_response_code(response_code)
    appt = property.appointment
    response = property.appointment.update_column(:user_response, appt_option)
    time = appointment_time(appt)
    bitly_cal = Bitly.client.shorten("https://7b3ddecf.ngrok.com/appointments/#{appt.calendar_url}/add").short_url
    
    tenant_msg = "Great! You're confirmed for #{time.strftime('%m/%d/%y %l:%M%P')} to meet #{property.broker.first_name} at #{property.address}. Click here to add the tour to your calendar #{bitly_cal}"
    broker_msg = "Hi #{property.broker.first_name}, James here. #{user.name} confirmed the #{time.strftime('%m/%d/%y %l:%M%P')} time for the #{property.address}, #{property.sq_ft}sq ft space. Click here to add the tour to your calendar #{bitly_cal}"

    # Send confirmation to user
    create_sms_msg(user.phone_number, tenant_msg)

    # Send confirmation to broker
    create_sms_msg(property.broker.phone_number, broker_msg)

  end


end
