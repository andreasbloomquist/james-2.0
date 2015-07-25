class PropertiesController < ApplicationController
  include SmsHelper
  include PropertiesHelper

  def create
    @property = Property.new(property_params)
    prop_exists_err = 
      'Sorry this property has already be reported by another broker for this lead.'    
    if Property.exists?(property_params)
      flash[:error] = prop_exists_err
      redirect_to :back
    elsif @property.save
      @property.image_url.load if @property.image_url != nil
      @phone_number = @property.lead.user.phone_number
      create_response_code @property
      send_property(@phone_number, @property)
      redirect_to thank_you_path(@property.lead.response_url)
    else
      redirect_to respond_to_lead_path(@property.lead.response_url)
    end
  end

  private

  def property_params
    params.require(:property).permit(:address, :sub_market, :property_type, :sq_ft, :available, :min, :max, :description, :rent_price, :lead_id, :broker_id, :image_url)
  end
end
