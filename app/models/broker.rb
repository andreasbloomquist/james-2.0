class Broker < ActiveRecord::Base
  has_many :properties
  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, :phone_number, presence: true
end
