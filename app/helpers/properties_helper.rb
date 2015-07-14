module PropertiesHelper
  
  def create_response_code(property)
    @prop = property
    code = @prop.address.delete(' ')[0..5].downcase
    # Check to see if response code exists
    if response_exists?(code)
      old_code = Property.where(["response_code like ?", "%#{code}%"]).last
      new_code = "#{old_code}1"
      @prop.update_column(:response_code, new_code)
    else
      @prop.update_column(:response_code, code)
    end
  end

  def response_exists?(resp_code)
    return true if Property.find_by_response_code(resp_code) != nil
  end

end
