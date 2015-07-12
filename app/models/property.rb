class Property < ActiveRecord::Base
	belongs_to :lead
	belongs_to :broker

end
