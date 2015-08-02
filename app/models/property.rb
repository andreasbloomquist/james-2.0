class Property < ActiveRecord::Base
  validates :address, :sub_market, :property_type, :sq_ft, :rent_price, :available, :lead_id, presence: true
  validates :sq_ft, :rent_price, numericality: true

  has_and_belongs_to_many :leads
  belongs_to :broker
  has_many :appointments
  has_uploadcare_group :image_url

  include PropertiesHelper

  def self.exists?(params)
    addy = params[:address].split[0..1].join(" ")
    lead_id = params[:lead_id]
    sq_ft = params[:sq_ft]
    return true if Property.where(["lead_id = ? and sq_ft = ? and address like ?", lead_id, sq_ft, "%#{addy}%"]).last != nil
  end

end
