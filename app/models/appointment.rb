class Appointment < ActiveRecord::Base
  belongs_to :broker
  belongs_to :property
  belongs_to :lead
  has_one :user
end
