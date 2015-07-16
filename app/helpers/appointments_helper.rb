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

  def send_appointment_confirmation(number)
    user = User.find_by_phone_number(number)
  end

  def send_available_times(appointment)
    user = appointment.property.lead.user
    available_times_msg = "Hey #{user.name}, I just heard back from the broker. Here are three times they're available to meet: #{appointment.option_one.strftime('%m/%d/%y %l:%M%P')}, reply w/ '1 #{appointment.property.response_code}' for this time. #{appointment.option_two.strftime('%m/%d/%y %l:%M%P')}, reply '2 #{appointment.property.response_code}' for this time. #{appointment.option_three.strftime('%m/%d/%y %l:%M%P')}, reply '3 #{appointment.property.response_code}' for this time."
    create_sms_msg(user.phone_number, available_times_msg)
  end

  def send_confirmation(number, body)
    user = User.find_by_phone_number(number)
    appt_option = body.split[0]
    response_code = body.split[1]
    property = Property.find_by_response_code(response_code)
    appt = property.appointment.update_column(:user_response, appt_optio)




  end
end
