class Appointment < ActiveRecord::Base
  belongs_to :broker
  belongs_to :property

end
