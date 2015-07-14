class Property < ActiveRecord::Base
	belongs_to :lead
	belongs_to :broker
  include PropertiesHelper


  def self.exists?(params)
    addy = params[:address].split[0..1]
    lead_id = params[:lead_id]
    sq_ft = params[:sq_ft]
    return true if Property.where(["lead_id = ? and sq_ft = ? and address like ?", lead_id, sq_ft, "%#{addy}%"]) != nil
  end

end
