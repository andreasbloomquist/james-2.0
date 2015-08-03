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
    user = appointment.lead.user
    available_times_msg = "Hey #{user.name}, I just heard back from the broker. Here are three times they're available to meet: #{appointment.option_one.strftime('%m/%d/%y %l:%M%P')}, reply w/ '1 #{appointment.property.response_code}' for this time. #{appointment.option_two.strftime('%m/%d/%y %l:%M%P')}, reply '2 #{appointment.property.response_code}' for this time. #{appointment.option_three.strftime('%m/%d/%y %l:%M%P')}, reply '3 #{appointment.property.response_code}' for this time."
    create_sms_msg(user.phone_number, available_times_msg)
  end

  def send_user_appt(user, appt)
    time = appointment_time(appt)
    bitly_cal = Bitly.client.shorten("https://www.textjames.co/appointments/#{appt.user_cal_url}/user").short_url
    tenant_msg = "Great! You're confirmed for #{time.strftime('%m/%d/%y %l:%M%P')} to meet #{appt.property.broker.first_name} at #{appt.property.address}. Click here to add the tour to your calendar #{bitly_cal}"
    create_sms_msg(user.phone_number, tenant_msg)
  end

  def send_broker_appt(broker, appt)
    time = appointment_time(appt)
    bitly_cal = Bitly.client.shorten("https://www.textjames.co/appointments/#{appt.broker_cal_url}/broker").short_url
    broker_msg = "Hi #{appt.property.broker.first_name}, James here. #{appt.lead.user.name} confirmed the #{time.strftime('%m/%d/%y %l:%M%P')} time for the #{appt.property.address}, #{appt.property.sq_ft}sq ft space. Click here to add the tour to your calendar #{bitly_cal}"
    create_sms_msg(broker.phone_number, broker_msg)
  end

  def appt_confirmation(number, body)
    user = User.find_by_phone_number(number)
    appt_option = body.split[0]
    response_code = body.split[1]
    property = Property.find_by_response_code(response_code)
    appt = Appointment.where("property_id = ? AND user_id = ?", property.id, user.id).last
    appt.update_column(:user_response, appt_option)
    send_user_appt(user, appt)
    send_broker_appt(appt.broker, appt)
    render nothing: true
  end

end
