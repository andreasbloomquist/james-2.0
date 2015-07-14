module PropertiesHelper
  def create_response_code(property)
    @prop = property
    code = @prop.address.delete(' ')[0..6]
    @prop.update_column(:response_code, code)
  end

end
