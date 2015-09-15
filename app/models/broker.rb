class Broker < ActiveRecord::Base
  has_many :properties
  validates :email, uniqueness: true
  validates :first_name, :last_name, :email, :phone_number, presence: true

  def self.is_broker?(number)
    @broker = Broker.find_by_phone_number(number)
    return @broker unless @broker == nil
  end

  def set_auth_code
    auth_code = rand(10000)
    auth_message = "Your authorization code is #{auth_code}"
    create_sms_msg(phone_number, auth_message)
  end

  private
  @@client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

  def create_sms_msg(to, body)
    @@client.messages.create({
        from: '+14158010226',
        to: to,
        body: body
      })
  end
end
