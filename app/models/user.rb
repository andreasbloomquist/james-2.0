class User < ActiveRecord::Base
	has_many :leads
  has_many :appointments
end
