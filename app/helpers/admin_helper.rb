module AdminHelper

  def total_users
    @user_count = User.count
  end

  def total_leads
    @lead_count = Lead.count(:complete)
  end

  def total_responses
    @response_count = Appointment.count
  end

  def response_rate
    property = Property.count()
    response = total_responses
    return (response.to_f / property)*100
  end
end
