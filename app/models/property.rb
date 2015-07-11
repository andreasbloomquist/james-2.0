class Property < ActiveRecord::Base
	belongs_to :leads
	belongs_to :brokers
end
