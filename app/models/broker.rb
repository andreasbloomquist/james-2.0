class Broker < ActiveRecord::Base
  has_many :properties
  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, :phone_number, presence: true

  def self.confirm_broker(number)
    @broker = Broker.find_by_phone_number(number)
    return @broker unless @broker === nil
  end
end
