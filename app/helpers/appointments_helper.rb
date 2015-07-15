module AppointmentsHelper
  include SmsHelper

  def send_available_times(appointment)
    user = appointment.property.lead.user
    available_times_msg = "Hey #{user.name}, I just heard back from the broker. Here are three times they're available to meet: #{appointment.option_one.strftime('%m/%d/%y %l:%M%P')}, reply '1' for this time. #{appointment.option_two.strftime('%m/%d/%y %l:%M%P')}, reply 2 for this time. #{appointment.option_three.strftime('%m/%d/%y %l:%M%P')}, reply 3 for this time."
    create_sms_msg(user.phone_number, available_times_msg)
  end
end
