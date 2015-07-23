class Property < ActiveRecord::Base
	belongs_to :lead
	belongs_to :broker
  has_one :appointment
  has_uploadcare_group :image_url

  include PropertiesHelper

  validates :address, :sub_market, :property_type, :sq_ft, :rent_price, :available, :lead_id, presence: true

  def self.exists?(params)
    addy = params[:address].split[0..1].join(" ")
    lead_id = params[:lead_id]
    sq_ft = params[:sq_ft]
    return true if Property.where(["lead_id = ? and sq_ft = ? and address like ?", lead_id, sq_ft, "%#{addy}%"]).last != nil
  end

end
