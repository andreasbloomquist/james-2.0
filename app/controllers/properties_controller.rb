class PropertiesController < ApplicationController
   http_basic_authenticate_with name: "text", password: "james"

  include SmsHelper
  include PropertiesHelper

  def create
    @property = Property.new(property_params)
    broker_id = cookies[:broker_id]
    prop_exists_err = "Sorry this property has already be reported by another broker for this lead."
    
    if Property.exists?(property_params)
      flash[:error] = prop_exists_err
      redirect_to :back
    elsif @property.save
      @phone_number = @property.lead.user.phone_number
      create_response_code @property
      @resposne_url = @property.lead.response_url

      send_property(@phone_number, @property)
      redirect_to thank_you_path(@resposne_url)
    else
      flash[:error] = '#{@property.errors.each {|e| e }}'
    end
  end

  private

  def property_params
    params.require(:property).permit(:address, :sub_market, :property_type, :sq_ft, :available, :min, :max, :description, :rent_price, :lead_id, :broker_id, :image_url)
  end
end
