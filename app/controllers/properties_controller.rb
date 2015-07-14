class PropertiesController < ApplicationController
  include SmsHelper
  include PropertiesHelper

  def create
    @property = Property.new(property_params)
    broker_id = cookies[:broker_id]
    
    if @property.save
      @phone_number = @property.lead.user.phone_number
      create_response_code @property
      @resposne_url = @property.lead.response_url

      send_property(@phone_number, @property)
      flash[:success] = 'Property successfully added and has been sent to the lead'
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
