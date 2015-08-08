module LeadsHelper

  def lead_complete?(number)
    user = User.find_by_phone_number(number)
    return user.leads.last.complete
  end

  def image(property)
    @file = property.image_url.load.files[0].cdn_url
    return @file
  end


end
