class Lead < ActiveRecord::Base
  belongs_to :user
  has_many :properties
  has_many :appointments
end
