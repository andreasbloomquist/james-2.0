module PropertiesHelper
  def create_response_code(property)
    @prop = property
    code = @prop.address.delete(' ')[0..6]
    @prop.update_column(:response_code, code)
  end

  def sanitize_address(address)
    split_addy = address.split[0..1]
    return split_addy
  end
end
