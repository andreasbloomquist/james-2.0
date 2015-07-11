class Property < ActiveRecord::Base
	belongs_to :leads, :brokers
end
