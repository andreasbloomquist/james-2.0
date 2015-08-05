module LeadsHelper

  def lead_complete?(number)
    user = User.find_by_phone_number(number)
    return user.leads.last.complete
  end

  def image(property)
    if property.image_url.files != nil
      @file = property.image_url.files[0].cdn_url
      return @file
    end
  end


end
