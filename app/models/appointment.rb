class Appointment < ActiveRecord::Base
  belongs_to :broker
  belongs_to :property
  validates :option_one, :option_two, :option_three, presence: true

end
