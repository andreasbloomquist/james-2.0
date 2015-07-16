module LeadsHelper

  def lead_complete?(number)
    user = User.find_by_phone_number(number)
    return user.leads.last.complete
  end
end
