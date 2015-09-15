class Lead < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :properties
  has_many :appointments

end
